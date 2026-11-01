import SwiftUI

public struct CategoryIconBadge: View {
    private let icon: CategoryIcon
    private let color: Color
    private let size: CGFloat

    public init(icon: CategoryIcon, color: Color, size: CGFloat = 32) {
        self.icon = icon
        self.color = color
        self.size = size
    }

    public var body: some View {
        icon.image
            .resizable()
            .scaledToFit()
            .foregroundStyle(color)
            .padding(size * 0.25)
            .frame(width: size, height: size)
            .background(color.opacity(0.14), in: RoundedRectangle(cornerRadius: size * 0.28))
            .accessibilityHidden(true)
    }
}
