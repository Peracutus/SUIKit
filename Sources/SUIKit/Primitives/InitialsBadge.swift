import SwiftUI

public struct InitialsBadge: View {
    private let name: String
    private let color: Color
    private let size: CGFloat

    public init(name: String, color: Color = Color(red: 0.55, green: 0.48, blue: 0.98), size: CGFloat = 36) {
        self.name = name
        self.color = color
        self.size = size
    }

    public var body: some View {
        Text(initials)
            .font(.system(size: size * 0.34, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(color.opacity(0.14), in: Circle())
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
