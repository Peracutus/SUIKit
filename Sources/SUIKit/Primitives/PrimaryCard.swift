import SwiftUI

public struct PrimaryCard<Content: View>: View {
    @Environment(\.colorSchemeContrast) private var contrast
    private let content: Content
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let useOptimizedShadow: Bool

    public init(
        cornerRadius: CGFloat = AppRadius.card,
        padding: CGFloat = AppSpacing.l,
        useOptimizedShadow: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.useOptimizedShadow = useOptimizedShadow
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(SemanticColors.card)
            .cornerRadius(cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(contrast == .increased ? SemanticColors.separator : .clear, lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .modifier(ShadowModifier(useOptimized: useOptimizedShadow))
    }
}

private struct ShadowModifier: ViewModifier {
    let useOptimized: Bool

    func body(content: Content) -> some View {
        if useOptimized {
            content.optimizedShadow()
        } else {
            content.shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        }
    }
}
