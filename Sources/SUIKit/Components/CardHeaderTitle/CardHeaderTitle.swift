//
//  CardHeaderTitle.swift
//  SUIKit
//
//  Переиспользуемая шапка карточки: иконка, заголовок, подзаголовок, кнопки share/edit
//

import SwiftUI

// MARK: - Constants



// MARK: - CardHeaderTitle

/// Шапка карточки с иконкой, заголовком, подзаголовком и опциональными кнопками
public struct CardHeaderTitle: View {
    
    enum CardHeaderTitleLayout {
        static let iconCircleSize: CGFloat = 30
        static let iconFontSize: CGFloat = 14
        static let primaryColor = Color(hex: "#6E77DD") ?? .purple
        static let buttonBackgroundColor = Color(hex: "#E4E4FB") ?? .purple.opacity(0.2)
        static public let subtitleColor = Color(hex: "#AAAAAA") ?? .gray
        static let titleFontSize: CGFloat = 16
        static let subtitleFontSize: CGFloat = 12
    }
    
    let iconName: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let subtitleColor: Color
    let onShare: (() -> Void)?
    let onEdit: (() -> Void)?

    public init(
        iconName: String,
        iconColor: Color = .white,
        title: String,
        subtitle: String,
        subtitleColor: Color = Color(hex: "#AAAAAA") ?? .gray,
        onShare: (() -> Void)? = nil,
        onEdit: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.onShare = onShare
        self.onEdit = onEdit
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(CardHeaderTitleLayout.primaryColor)
                    .frame(width: CardHeaderTitleLayout.iconCircleSize, height: CardHeaderTitleLayout.iconCircleSize)
                Image(systemName: iconName)
                    .font(.system(size: CardHeaderTitleLayout.iconFontSize))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Manrope-SemiBold", size: CardHeaderTitleLayout.titleFontSize))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: CardHeaderTitleLayout.subtitleFontSize, weight: .regular))
                    .foregroundColor(subtitleColor)
            }

            Spacer()

            HStack(spacing: 8) {
                if let onShare {
                    iconButton(iconName: "square.and.arrow.up", action: onShare)
                }
                if let onEdit {
                    iconButton(iconName: "pencil", action: onEdit)
                }
            }
        }
    }

    private func iconButton(iconName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(CardHeaderTitleLayout.buttonBackgroundColor)
                    .frame(width: CardHeaderTitleLayout.iconCircleSize, height: CardHeaderTitleLayout.iconCircleSize)
                Image(systemName: iconName)
                    .font(.system(size: CardHeaderTitleLayout.iconFontSize))
                    .foregroundColor(CardHeaderTitleLayout.primaryColor)
            }
        }
        .buttonStyle(.plain)
    }
}
