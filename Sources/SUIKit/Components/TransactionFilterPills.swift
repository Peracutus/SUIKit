import SwiftUI

public struct TransactionFilterPills: View {
    public let regularSelected: Bool
    public let splitSelected: Bool
    public let onRegularTap: () -> Void
    public let onSplitTap: () -> Void

    public init(
        regularSelected: Bool,
        splitSelected: Bool,
        onRegularTap: @escaping () -> Void,
        onSplitTap: @escaping () -> Void
    ) {
        self.regularSelected = regularSelected
        self.splitSelected = splitSelected
        self.onRegularTap = onRegularTap
        self.onSplitTap = onSplitTap
    }

    public var body: some View {
        HStack(spacing: 6) {
            pill("Регулярные", symbol: "repeat", selected: regularSelected, action: onRegularTap)
                .accessibilityIdentifier("dashboard.filter.regular")
            pill("Сплит", symbol: "scissors", selected: splitSelected, action: onSplitTap)
                .accessibilityIdentifier("dashboard.filter.split")
        }
    }

    private func pill(_ title: String, symbol: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbol)
                .font(.caption.weight(.medium))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundStyle(selected ? DashboardListStyle.filterSelectedText : DashboardListStyle.secondaryText)
                .padding(.horizontal, 8)
                .frame(minHeight: 28)
                .background(selected ? DashboardListStyle.filterSelectedFill : DashboardListStyle.filterFill, in: Capsule())
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(selected ? "Выбрано" : "Не выбрано")
    }
}
