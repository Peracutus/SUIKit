import SwiftUI

/// A compact settings action used in help and feedback cards.
public struct SettingsCompactActionRow: View {
    private let icon: SettingsIcon
    private let title: String
    private let action: () -> Void

    public init(icon: SettingsIcon, title: String, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                SettingsIconBadge(icon: icon, size: 36, drawsBorder: true)

                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            .frame(minHeight: 36)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
