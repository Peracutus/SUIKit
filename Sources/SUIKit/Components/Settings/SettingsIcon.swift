import SwiftUI

/// Icons used by the settings screen. New symbols are imported from the Figma settings icon set.
public enum SettingsIcon: Sendable {
    case language
    case currency
    case categories
    case notifications
    case terms
    case faceID
    case faq
    case feedback

    fileprivate var assetName: String {
        switch self {
        case .language: "SettingsLanguage"
        case .currency: "SettingsCurrency"
        case .categories: "SettingsCategories"
        case .notifications: "SettingsNotification"
        case .terms: "SettingsTerms"
        case .faceID: "SettingsFaceID"
        case .faq: "info"
        case .feedback: "feedback"
        }
    }

    fileprivate var requiresBorderedBadge: Bool {
        switch self {
        case .terms, .faceID, .faq, .feedback:
            true
        case .language, .currency, .categories, .notifications:
            false
        }
    }

    /// The icon rendered with the colors authored in the asset.
    public var image: Image {
        Image(assetName, bundle: .module)
            .renderingMode(.original)
    }
}

struct SettingsIconBadge: View {
    let icon: SettingsIcon
    let size: CGFloat
    let drawsBorder: Bool

    init(icon: SettingsIcon, size: CGFloat, drawsBorder: Bool? = nil) {
        self.icon = icon
        self.size = size
        self.drawsBorder = drawsBorder ?? icon.requiresBorderedBadge
    }

    var body: some View {
        icon.image
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .frame(width: size, height: size)
            .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                if drawsBorder {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(
                            Color(red: 243 / 255, green: 244 / 255, blue: 246 / 255),
                            lineWidth: 1
                        )
                }
            }
            .accessibilityHidden(true)
    }
}
