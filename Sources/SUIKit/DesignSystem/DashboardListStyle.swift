import SwiftUI

/// Semantic surfaces used by the Dashboard transaction feed.
public enum DashboardListStyle {
    public static let canvas = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? .secondarySystemBackground
            : UIColor(red: 245 / 255, green: 245 / 255, blue: 247 / 255, alpha: 1)
    })
    public static let card = Color(uiColor: .systemBackground)
    public static let border = Color(uiColor: .separator)
    public static let primaryText = Color.primary
    public static let secondaryText = Color.secondary
    public static let filterFill = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? .tertiarySystemFill
            : UIColor(red: 238 / 255, green: 237 / 255, blue: 245 / 255, alpha: 1)
    })
    public static let filterSelectedFill = Color.accentColor.opacity(0.18)
    public static let filterSelectedText = Color.accentColor
    public static let income = Color(hex: "#047857") ?? .green
}
