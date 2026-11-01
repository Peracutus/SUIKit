import SwiftUI
import UIKit
import XCTest
@testable import SUIKit

@MainActor
final class NativeBackButtonStyleTests: XCTestCase {
    func testRootPreparesPreviousItemWithoutStylingRootActions() {
        let root = UIViewController()
        root.navigationItem.backButtonDisplayMode = .generic
        let navigation = UINavigationController(rootViewController: root)
        let registry = NativeBackButtonStyleRegistry()
        let owner = UUID()

        registry.update(owner: owner, host: root, navigationController: navigation)

        XCTAssertEqual(root.navigationItem.backButtonDisplayMode, .minimal)
        XCTAssertNil(root.navigationItem.standardAppearance)
        XCTAssertNil(root.navigationItem.backBarButtonItem)
        XCTAssertFalse(root.navigationItem.hidesBackButton)

        registry.release(owner: owner)
        XCTAssertEqual(root.navigationItem.backButtonDisplayMode, .generic)
    }

    func testPushPreservesNativeIndicatorAndNilAppearances() {
        let root = UIViewController()
        let destination = UIViewController()
        let navigation = UINavigationController(rootViewController: root)
        navigation.setViewControllers([root, destination], animated: false)
        let save = UIBarButtonItem(title: "Сохранить", style: .done, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Отмена", style: .plain, target: nil, action: nil)
        destination.navigationItem.rightBarButtonItem = save
        destination.navigationItem.leftBarButtonItem = cancel
        let originalBarTint = navigation.navigationBar.tintColor
        let originalGestureDelegate = navigation.interactivePopGestureRecognizer?.delegate
        let registry = NativeBackButtonStyleRegistry()
        let owner = UUID()

        registry.update(owner: owner, host: destination, navigationController: navigation)

        XCTAssertEqual(root.navigationItem.backButtonDisplayMode, .minimal)
        XCTAssertEqual(destination.navigationItem.backButtonDisplayMode, .minimal)
        XCTAssertNil(destination.navigationItem.standardAppearance)
        XCTAssertNil(destination.navigationItem.compactAppearance)
        XCTAssertNil(destination.navigationItem.scrollEdgeAppearance)
        XCTAssertNil(destination.navigationItem.compactScrollEdgeAppearance)
        XCTAssertTrue(destination.navigationItem.rightBarButtonItem === save)
        XCTAssertTrue(destination.navigationItem.leftBarButtonItem === cancel)
        XCTAssertEqual(navigation.navigationBar.tintColor, originalBarTint)
        XCTAssertTrue(navigation.interactivePopGestureRecognizer?.delegate === originalGestureDelegate)
        XCTAssertNil(destination.navigationItem.backBarButtonItem)
        XCTAssertFalse(destination.navigationItem.hidesBackButton)

        registry.release(owner: owner)
        XCTAssertNil(destination.navigationItem.standardAppearance)
        XCTAssertNil(destination.navigationItem.compactAppearance)
        XCTAssertNil(destination.navigationItem.scrollEdgeAppearance)
        XCTAssertNil(destination.navigationItem.compactScrollEdgeAppearance)
        XCTAssertEqual(root.navigationItem.backButtonDisplayMode, .default)
    }

    func testAdjacentScreenLeasesKeepPreviousItemMinimalUntilLastOwnerLeaves() {
        let root = UIViewController()
        let first = UIViewController()
        let second = UIViewController()
        let navigation = UINavigationController(rootViewController: root)
        navigation.setViewControllers([root, first, second], animated: false)
        let registry = NativeBackButtonStyleRegistry()
        let firstOwner = UUID()
        let secondOwner = UUID()

        registry.update(owner: firstOwner, host: first, navigationController: navigation)
        registry.update(owner: secondOwner, host: second, navigationController: navigation)
        registry.release(owner: firstOwner)

        XCTAssertEqual(first.navigationItem.backButtonDisplayMode, .minimal)
        registry.release(owner: secondOwner)
        XCTAssertEqual(first.navigationItem.backButtonDisplayMode, .default)
        XCTAssertEqual(second.navigationItem.backButtonDisplayMode, .default)
    }

    func testExistingAppearanceAndUnrelatedButtonStylesSurviveRoundTrip() {
        let root = UIViewController()
        let destination = UIViewController()
        let navigation = UINavigationController(rootViewController: root)
        navigation.setViewControllers([root, destination], animated: false)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .yellow
        appearance.titleTextAttributes = [.foregroundColor: UIColor.purple]
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.green]
        destination.navigationItem.standardAppearance = appearance
        let registry = NativeBackButtonStyleRegistry()
        let owner = UUID()

        registry.update(owner: owner, host: destination, navigationController: navigation)
        let styled = destination.navigationItem.standardAppearance
        XCTAssertTrue(styled === appearance)
        XCTAssertEqual(styled?.backIndicatorImage.alignmentRectInsets, appearance.backIndicatorImage.alignmentRectInsets)
        XCTAssertEqual(styled?.backIndicatorTransitionMaskImage.alignmentRectInsets, appearance.backIndicatorTransitionMaskImage.alignmentRectInsets)
        XCTAssertEqual(styled?.backgroundColor, .yellow)
        XCTAssertEqual(styled?.titleTextAttributes[.foregroundColor] as? UIColor, .purple)
        XCTAssertEqual(styled?.buttonAppearance.normal.titleTextAttributes[.foregroundColor] as? UIColor, .green)
        registry.release(owner: owner)
        XCTAssertEqual(destination.navigationItem.standardAppearance?.backgroundColor, .yellow)
        XCTAssertEqual(destination.navigationItem.standardAppearance?.backIndicatorImage.renderingMode, appearance.backIndicatorImage.renderingMode)
    }

    func testTeardownDoesNotOverwriteNewExternalAppearance() {
        let root = UIViewController()
        let destination = UIViewController()
        let navigation = UINavigationController(rootViewController: root)
        navigation.setViewControllers([root, destination], animated: false)
        let registry = NativeBackButtonStyleRegistry()
        let owner = UUID()
        registry.update(owner: owner, host: destination, navigationController: navigation)

        let replacement = UINavigationBarAppearance()
        replacement.backgroundColor = .orange
        destination.navigationItem.standardAppearance = replacement
        destination.navigationItem.backButtonDisplayMode = .generic
        registry.release(owner: owner)

        XCTAssertEqual(destination.navigationItem.standardAppearance?.backgroundColor, .orange)
        XCTAssertEqual(destination.navigationItem.backButtonDisplayMode, .generic)
    }

    func testProbeFindsContainingHostUsingPublicParentChain() {
        let root = UIViewController()
        let navigation = UINavigationController(rootViewController: root)
        let intermediate = UIViewController()
        let probe = NativeBackButtonStyleController()
        root.addChild(intermediate)
        intermediate.didMove(toParent: root)
        intermediate.addChild(probe)
        probe.didMove(toParent: intermediate)

        XCTAssertTrue(probe.navigationContext()?.host === root)
        XCTAssertTrue(probe.navigationContext()?.navigationController === navigation)
        probe.stop()
        XCTAssertEqual(root.navigationItem.backButtonDisplayMode, .default)
    }
}
