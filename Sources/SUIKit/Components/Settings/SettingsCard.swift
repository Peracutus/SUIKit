import SwiftUI

/// Visual variants for grouped settings content.
public enum SettingsCardStyle: Sendable {
    /// Standard list rows with a 60 pt minimum height.
    case regular

    /// Compact action rows with a 36 pt minimum height.
    case compact

    fileprivate var contentInsets: EdgeInsets {
        switch self {
        case .regular:
            EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        case .compact:
            EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18)
        }
    }

    fileprivate var rowSpacing: CGFloat {
        switch self {
        case .regular: 0
        case .compact: 16
        }
    }
}

/// A titled rounded card for settings rows.
public struct SettingsCard<Content: View>: View {
    private let title: String
    private let style: SettingsCardStyle
    private let content: Content

    public init(
        title: String,
        style: SettingsCardStyle = .regular,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.style = style
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: style.rowSpacing) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(style.contentInsets)
            .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
