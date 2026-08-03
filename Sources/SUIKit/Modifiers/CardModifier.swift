import SwiftUI

public struct CardStyle: ViewModifier {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    
    public init(cornerRadius: CGFloat = AppRadius.card, padding: CGFloat = AppSpacing.m) {
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.cardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

public extension View {
    func cardStyle(cornerRadius: CGFloat = AppRadius.card, padding: CGFloat = AppSpacing.m) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius, padding: padding))
    }
}

