import SwiftUI

/// A standard settings row with a native switch control.
public struct SettingsToggleRow: View {
    private let icon: SettingsIcon
    private let title: String
    @Binding private var isOn: Bool

    public init(icon: SettingsIcon, title: String, isOn: Binding<Bool>) {
        self.icon = icon
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 12) {
                SettingsIconBadge(icon: icon, size: 40)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
            }
        }
        .tint(Self.accent)
        .padding(.horizontal, 18)
        .frame(minHeight: 60)
        .accessibilityLabel(title)
    }

    private static let accent = Color(
        red: 102 / 255,
        green: 127 / 255,
        blue: 254 / 255
    )
}
