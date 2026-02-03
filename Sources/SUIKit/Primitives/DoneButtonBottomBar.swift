//
//  DoneButtonBottomBar.swift
//  SUIKit
//
//  Нижняя панель с кнопкой «Готово» (safeAreaInset).
//  Используется в SplitDetailsSheet, TransactionDetailView.
//

import SwiftUI

/// Нижняя панель с кнопкой «Готово» для safeAreaInset.
/// Поддерживает опциональный отступ при открытой клавиатуре.
public struct DoneButtonBottomBar: View {
    let title: String
    let action: () -> Void
    var keyboardHeight: CGFloat = 0

    public init(
        title: String = "Готово",
        keyboardHeight: CGFloat = 0,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.keyboardHeight = keyboardHeight
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#6E77DD") ?? .purple)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, keyboardHeight > 0 ? 12 : 0)
            if keyboardHeight > 0 {
                Color.clear
                    .frame(height: 20)
            }
        }
        .padding(.top, 12)
        .background(Color(.systemGroupedBackground))
    }
}

public extension View {
    /// Добавляет нижнюю панель с кнопкой «Готово» через safeAreaInset.
    func doneButtonBottomBar(
        title: String = "Готово",
        keyboardHeight: CGFloat = 0,
        action: @escaping () -> Void
    ) -> some View {
        safeAreaInset(edge: .bottom) {
            DoneButtonBottomBar(title: title, keyboardHeight: keyboardHeight, action: action)
        }
    }
}
