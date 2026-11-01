import SwiftUI

/// The upper contour fades away as the card meets the screen edges. The lower
/// contour is drawn separately and remains visible in the pinned presentation.
struct BudgetCardCollapseUpperBorder: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let bounds = rect.insetBy(dx: 0.5, dy: 0.5)
        let topRadius = max(0, 16 * min(max(progress, 0), 1) - 0.5)
        let bottomRadius = min(15.5, bounds.width / 2, bounds.height / 2)
        var path = Path()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY - bottomRadius))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topRadius))
        path.addQuadCurve(
            to: CGPoint(x: bounds.minX + topRadius, y: bounds.minY),
            control: CGPoint(x: bounds.minX, y: bounds.minY)
        )
        path.addLine(to: CGPoint(x: bounds.maxX - topRadius, y: bounds.minY))
        path.addQuadCurve(
            to: CGPoint(x: bounds.maxX, y: bounds.minY + topRadius),
            control: CGPoint(x: bounds.maxX, y: bounds.minY)
        )
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRadius))
        return path
    }
}
