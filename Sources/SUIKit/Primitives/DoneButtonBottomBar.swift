//
//  DoneButtonBottomBar.swift
//  SUIKit
//
//  Нижняя панель с кнопкой «Готово» (safeAreaInset).
//  Используется в SplitDetailsSheet, TransactionDetailView.
//

import SwiftUI

/// Visual presentation for a single bottom action.
/// The default retains the existing forms and detail-screen appearance.
public enum DoneButtonBottomBarPresentation {
    case standard
    case floating
    case barePill
}

/// Нижняя панель с кнопкой «Готово» для safeAreaInset.
/// Поддерживает опциональный отступ при открытой клавиатуре.
public struct DoneButtonBottomBar: View {
    let title: String
    let action: () -> Void
    var keyboardHeight: CGFloat = 0
    var isEnabled: Bool = true
    var presentation: DoneButtonBottomBarPresentation = .standard
    var secondaryTitle: String?
    var secondaryAction: (() -> Void)?

    public init(
        title: String = "Готово",
        keyboardHeight: CGFloat = 0,
        isEnabled: Bool = true,
        presentation: DoneButtonBottomBarPresentation = .standard,
        secondaryTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.keyboardHeight = keyboardHeight
        self.isEnabled = isEnabled
        self.presentation = presentation
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isEnabled ? SemanticColors.onAccent : SemanticColors.disabledText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, presentation == .standard ? 14 : 0)
                    .frame(height: floatingButtonHeight)
                    .background(isEnabled ? SemanticColors.accent : SemanticColors.disabledFill)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
            .disabled(!isEnabled)
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, keyboardHeight > 0 ? 12 : 0)
            if let secondaryTitle, let secondaryAction {
                Button(action: secondaryAction) {
                    Text(secondaryTitle)
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundStyle(SemanticColors.selectedText)
                        .background(SemanticColors.selectedFill, in: Capsule())
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            }
            if keyboardHeight > 0 {
                Color.clear
                    .frame(height: 20)
            }
        }
        .padding(.top, topPadding)
        .frame(minHeight: bottomBarMinimumHeight, alignment: .top)
        .background(bottomBarBackground)
    }

    private var cornerRadius: CGFloat {
        switch presentation {
        case .standard: 12
        case .floating: 26
        case .barePill: 60
        }
    }

    private var horizontalPadding: CGFloat {
        switch presentation {
        case .standard: 16
        case .floating: 20
        case .barePill: 16
        }
    }

    private var topPadding: CGFloat {
        switch presentation {
        case .standard: 12
        case .floating: 8
        case .barePill: 0
        }
    }

    private var floatingButtonHeight: CGFloat? {
        switch presentation {
        case .standard: nil
        case .floating, .barePill: 48
        }
    }

    private var bottomBarMinimumHeight: CGFloat? {
        switch presentation {
        case .standard: nil
        case .floating: 92
        case .barePill: nil
        }
    }

    @ViewBuilder
    private var bottomBarBackground: some View {
        switch presentation {
        case .standard:
            SemanticColors.footer
        case .floating:
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 24,
                style: .continuous
            )
            .fill(SemanticColors.footer)
        case .barePill:
            Color.clear
        }
    }
}

public extension View {
    /// Добавляет нижнюю панель с кнопкой «Готово» через safeAreaInset.
    func doneButtonBottomBar(
        title: String = "Готово",
        keyboardHeight: CGFloat = 0,
        isEnabled: Bool = true,
        presentation: DoneButtonBottomBarPresentation = .standard,
        action: @escaping () -> Void
    ) -> some View {
        safeAreaInset(edge: .bottom) {
            DoneButtonBottomBar(
                title: title,
                keyboardHeight: keyboardHeight,
                isEnabled: isEnabled,
                presentation: presentation,
                action: action
            )
        }
    }
}
