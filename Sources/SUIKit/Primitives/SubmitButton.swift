//
//  SubmitButton.swift
//  SUIKit
//
//  Created by Роман Рунов on 02.04.2025.
//

import SwiftUI

/// Стиль кнопки: заливка или обводка (частные свойства в кейсах, общие — в ините SubmitButton).
public enum SubmitButtonStyle {
    /// Заливка фоном, текст белый.
    case filled(backgroundColor: Color)
    /// Фон systemBackground, обводка и текст — accentColor.
    case outline(accentColor: Color)
}

/// Переиспользуемая кнопка подтверждения/отмены с выбором стиля.
public struct SubmitButton: View {
    private let title: String
    private let style: SubmitButtonStyle
    private let action: () -> Void
    private let font: Font
    private let cornerRadius: CGFloat
    private let height: CGFloat = 48

    public init(
        title: String,
        style: SubmitButtonStyle,
        action: @escaping () -> Void,
        font: Font = .system(size: 17, weight: .semibold),
        cornerRadius: CGFloat = 60
    ) {
        self.title = title
        self.style = style
        self.action = action
        self.font = font
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(backgroundColor)
                .overlay(outlineOverlay)
                .cornerRadius(cornerRadius)
        }
        .buttonStyle(.plain)
    }

    private var textColor: Color {
        switch style {
        case .filled:
            return .white
        case .outline(let accentColor):
            return accentColor
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .filled(let color):
            return color
        case .outline:
            return Color(uiColor: .systemBackground)
        }
    }

    @ViewBuilder
    private var outlineOverlay: some View {
        switch style {
        case .filled:
            EmptyView()
        case .outline(let accentColor):
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(accentColor, lineWidth: 1)
        }
    }
}
