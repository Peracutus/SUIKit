import SwiftUI
import UIKit

/// Shared color roles. System surfaces and labels adapt to Dark Mode and
/// Increased Contrast; custom brand colors also provide explicit contrast variants.
public enum SemanticColors {
    public static let screen = Color(uiColor: .systemGroupedBackground)
    public static let card = Color(uiColor: .secondarySystemGroupedBackground)
    public static let sheet = Color(uiColor: .systemBackground)
    public static let footer = sheet
    public static let primaryText = Color(uiColor: .label)
    public static let secondaryText = Color(uiColor: .secondaryLabel)
    public static let separator = Color(uiColor: .opaqueSeparator)
    public static let controlFill = Color(uiColor: .tertiarySystemGroupedBackground)

    public static let accent = adaptive(
        light: 0x606BC8, dark: 0xA5AEFF,
        increasedLight: 0x4D58AC, increasedDark: 0xBDC5FF
    )
    public static let onAccent = adaptive(light: 0xFFFFFF, dark: 0x11182F)
    public static let selectedFill = adaptive(
        light: 0xE4E4FB, dark: 0x293354,
        increasedLight: 0xD1D5F4, increasedDark: 0x394B73
    )
    public static let selectedText = adaptive(
        light: 0x4D58AC, dark: 0xA5AEFF,
        increasedLight: 0x39448C, increasedDark: 0xE0E4FF
    )
    public static let disabledFill = adaptive(light: 0xDCDEE8, dark: 0x343742)
    public static let disabledText = secondaryText
    public static let income = adaptive(
        light: 0x047857, dark: 0x4DDBAA,
        increasedLight: 0x005F43, increasedDark: 0x75EBC2
    )
    public static let destructive = Color(uiColor: .systemRed)

    private static func adaptive(
        light: UInt32, dark: UInt32,
        increasedLight: UInt32? = nil, increasedDark: UInt32? = nil
    ) -> Color {
        Color(uiColor: UIColor { traits in
            let darkMode = traits.userInterfaceStyle == .dark
            let increased = traits.accessibilityContrast == .high
            let value = darkMode
                ? (increased ? increasedDark ?? dark : dark)
                : (increased ? increasedLight ?? light : light)
            return UIColor(
                red: CGFloat((value >> 16) & 255) / 255,
                green: CGFloat((value >> 8) & 255) / 255,
                blue: CGFloat(value & 255) / 255,
                alpha: 1
            )
        })
    }
}
