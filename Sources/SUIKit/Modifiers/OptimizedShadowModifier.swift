import SwiftUI

public struct OptimizedShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: SizePreferenceKey.self,
                        value: geometry.size
                    )
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { size in
                // Размер известен, но мы используем встроенную оптимизацию SwiftUI
            }
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    public func optimizedShadow(
        color: Color = .black.opacity(0.08),
        radius: CGFloat = 4,
        x: CGFloat = 0,
        y: CGFloat = 2
    ) -> some View {
        modifier(OptimizedShadowModifier(color: color, radius: radius, x: x, y: y))
    }
}

