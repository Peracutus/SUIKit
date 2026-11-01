import Foundation

/// Resolve the end of every drag, including one that changed direction after
/// revealing part of the action. A vertical finish must restore the settled row.
enum TransactionRowSwipeOutcome: Equatable {
    case closed
    case revealed
    case delete

    /// Direction has already been locked by the recognizer. Deletion requires
    /// actual travel; a fast short swipe may reveal the action but cannot delete.
    static func resolveHorizontal(translation: CGFloat, velocity: CGFloat, origin: CGFloat) -> Self {
        let actualOffset = origin + translation
        if actualOffset <= -145 { return .delete }
        return actualOffset + velocity * 0.15 <= -48 ? .revealed : .closed
    }

    static func resolve(
        translation: CGSize,
        predictedEndTranslation: CGSize,
        wasRevealed: Bool
    ) -> Self {
        guard abs(translation.width) > abs(translation.height) * 1.25 else {
            return wasRevealed ? .revealed : .closed
        }
        let projected = (wasRevealed ? -72.0 : 0) + predictedEndTranslation.width
        if projected <= -145 { return .delete }
        return projected <= -48 ? .revealed : .closed
    }
}
