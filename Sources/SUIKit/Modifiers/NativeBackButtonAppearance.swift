import UIKit

@MainActor
final class NativeBackButtonAppearance {
    // UIKit's native back item places the indicator a few points inside the
    // bar's leading edge. The design system aligns it with the 20pt screen
    // margin, so shift only the indicator's alignment rect while keeping the
    // native button and its hit target intact.
    private static let designLeadingInset: CGFloat = 8

    weak var item: UINavigationItem?
    var owners: Set<UUID> = []
    private var originals: [UINavigationBarAppearance?]
    private var installed: [UINavigationBarAppearance?] = Array(repeating: nil, count: 4)
    private var lastTint: UIColor?

    init(item: UINavigationItem) {
        self.item = item
        originals = Self.read(item)
    }

    func apply(tint: UIColor, navigationBar: UINavigationBar) {
        guard let item else { return }
        let current = Self.read(item)
        let unchanged = zip(current, installed).allSatisfy { $0 === $1 }
        guard lastTint == nil || lastTint != tint || !unchanged else { return }

        // Respect appearance updates made by SwiftUI while this screen is alive.
        // Save their latest baseline, rather than restoring a stale snapshot later.
        for index in current.indices where current[index] !== installed[index] {
            originals[index] = current[index]
        }

        let standard = originals[0] ?? navigationBar.standardAppearance
        let compact = originals[1] ?? navigationBar.compactAppearance ?? standard
        let scrollEdge: UINavigationBarAppearance
        if let explicit = originals[2] ?? navigationBar.scrollEdgeAppearance {
            scrollEdge = explicit
        } else {
            // UIKit's documented nil scroll-edge fallback is standard appearance
            // with a transparent background. Retain title and button settings.
            scrollEdge = UINavigationBarAppearance(barAppearance: standard)
            scrollEdge.configureWithTransparentBackground()
        }
        let compactScrollEdge = originals[3] ?? navigationBar.compactScrollEdgeAppearance ?? scrollEdge
        let styled = [standard, compact, scrollEdge, compactScrollEdge].map { source in
            let copy = UINavigationBarAppearance(barAppearance: source)
            let indicator = source.backIndicatorImage
                .withTintColor(tint, renderingMode: .alwaysOriginal)
                .withAlignmentRectInsets(
                    UIEdgeInsets(
                        top: source.backIndicatorImage.alignmentRectInsets.top,
                        left: source.backIndicatorImage.alignmentRectInsets.left - Self.designLeadingInset,
                        bottom: source.backIndicatorImage.alignmentRectInsets.bottom,
                        right: source.backIndicatorImage.alignmentRectInsets.right
                    )
                )
            let transitionMask = source.backIndicatorTransitionMaskImage
                .withAlignmentRectInsets(
                    UIEdgeInsets(
                        top: source.backIndicatorTransitionMaskImage.alignmentRectInsets.top,
                        left: source.backIndicatorTransitionMaskImage.alignmentRectInsets.left - Self.designLeadingInset,
                        bottom: source.backIndicatorTransitionMaskImage.alignmentRectInsets.bottom,
                        right: source.backIndicatorTransitionMaskImage.alignmentRectInsets.right
                    )
                )
            copy.setBackIndicatorImage(
                indicator,
                transitionMaskImage: transitionMask
            )
            return copy
        }
        Self.write(styled.map(Optional.some), to: item)
        installed = Self.read(item)
        lastTint = tint
    }

    func restore() {
        guard let item else { return }
        var values = Self.read(item)
        for index in values.indices where values[index] === installed[index] {
            values[index] = originals[index]
        }
        Self.write(values, to: item)
    }

    private static func read(_ item: UINavigationItem) -> [UINavigationBarAppearance?] {
        [item.standardAppearance, item.compactAppearance, item.scrollEdgeAppearance, item.compactScrollEdgeAppearance]
    }

    private static func write(_ values: [UINavigationBarAppearance?], to item: UINavigationItem) {
        item.standardAppearance = values[0]
        item.compactAppearance = values[1]
        item.scrollEdgeAppearance = values[2]
        item.compactScrollEdgeAppearance = values[3]
    }
}
