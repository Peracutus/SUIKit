import SwiftUI

enum BudgetCardStyle {
    static let border = Color(hex: "#E5E7EB") ?? .gray.opacity(0.2)
    static let primaryText = Color(hex: "#111827") ?? .primary
    static let secondaryText = Color(hex: "#667085") ?? .secondary
    static let green = Color(hex: "#047857") ?? .green
    static let greenBackground = Color(hex: "#F0FDF4") ?? .green.opacity(0.08)
    static let red = Color(hex: "#9F1239") ?? .red
    static let redBackground = Color(hex: "#FFF1F2") ?? .red.opacity(0.08)
    static let blue = Color(hex: "#2563EB") ?? .blue
    static let blueBackground = Color(hex: "#EFF6FF") ?? .blue.opacity(0.08)
    static let purple = Color(hex: "#7C3AED") ?? .purple
    static let purpleBackground = Color(hex: "#F5F0FF") ?? .purple.opacity(0.08)
    static let savingsBackground = Color(hex: "#E8F5E9") ?? .green.opacity(0.1)
    static let savingsTagText = Color(hex: "#1B5E20") ?? .green
    static let neutralTile = Color(hex: "#F5F5F7") ?? .gray.opacity(0.08)
    static let savingsProgress = Color(hex: "#10B981") ?? .mint
}
