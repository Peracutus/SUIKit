import SwiftUI

public struct SectionTitleModifier: ViewModifier {
    let alignment: TextAlignment
    
    public init(alignment: TextAlignment = .leading) {
        self.alignment = alignment
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.primary)
            .lineSpacing(18 * 0.5)
            .multilineTextAlignment(alignment)
    }
}

extension View {
    public func sectionTitleStyle(alignment: TextAlignment = .leading) -> some View {
        modifier(SectionTitleModifier(alignment: alignment))
    }
}

