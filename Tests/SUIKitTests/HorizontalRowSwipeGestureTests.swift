import XCTest
@testable import SUIKit

@MainActor
final class HorizontalRowSwipeGestureTests: XCTestCase {
    func testVerticalAndDiagonalMovementYieldToScroll() {
        for movement in [CGPoint.zero, CGPoint(x: 0, y: 80), CGPoint(x: 20, y: 80), CGPoint(x: -60, y: 60)] {
            XCTAssertFalse(HorizontalRowSwipeGesture.Coordinator.isHorizontal(movement))
        }
    }

    func testBothHorizontalDirectionsCanRevealAndCloseSwipe() {
        XCTAssertTrue(HorizontalRowSwipeGesture.Coordinator.isHorizontal(CGPoint(x: -80, y: 10)))
        XCTAssertTrue(HorizontalRowSwipeGesture.Coordinator.isHorizontal(CGPoint(x: 80, y: -10)))
    }
}
