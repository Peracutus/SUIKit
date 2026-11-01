import SwiftUI

public enum InitialsBadgeShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat)
}

public struct InitialsBadge: View {
    private let name: String
    private let color: Color
    private let size: CGFloat
    private let shape: InitialsBadgeShape
    private let textSize: CGFloat?

    public init(name: String, color: Color = Color(red: 0.55, green: 0.48, blue: 0.98), size: CGFloat = 36, shape: InitialsBadgeShape = .circle, textSize: CGFloat? = nil) {
        self.name = name
        self.color = color
        self.size = size
        self.shape = shape
        self.textSize = textSize
    }

    public var body: some View {
        Text(initials)
            .font(.system(size: textSize ?? size * 0.34, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background {
                switch shape {
                case .circle:
                    Circle().fill(color.opacity(0.14))
                case let .roundedRectangle(cornerRadius):
                    RoundedRectangle(cornerRadius: cornerRadius).fill(color.opacity(0.14))
                }
            }
            .accessibilityHidden(true)
    }

    private var initials: String {
        name.split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
    }
}
