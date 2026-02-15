//
//  SwipeableParticipantRow.swift
//  SUIKit
//
//  Переиспользуемая строка участника со свайпом (удаление, отметка возврата долга)
//

import SwiftUI
import SwipeActions

/// Цвета для свайп-действий
private enum SwipeableColors {
    static let swipeZoneBackground = Color(hex: "#F5F5F9") ?? Color(uiColor: .systemGray6)
    static let deleteBackground = Color(hex: "#DE4D5D") ?? .red
    /// Зелёный — поставить отметку о выполнении (paid = false)
    static let markPaidBackground = Color(hex: "#87BD00") ?? .green
    /// Оранжевый — убрать отметку (paid = true)
    static let undoPaidBackground = Color(hex: "#F5A623") ?? .orange
    static let actionIcon = Color.white
}

/// Иконка для SwipeAction (цвет задаётся через background)
private func swipeActionIcon(_ name: String, isCheckmark: Bool = false) -> some View {
    Image(systemName: name)
        .font(.system(size: 14, weight: isCheckmark ? .semibold : .regular))
        .foregroundColor(SwipeableColors.actionIcon)
}

/// Цвет фона зоны свайпа (#F5F5F9) для применения на контейнере строк
public enum SwipeableParticipantRowStyle {
    public static let swipeZoneBackgroundColor = Color(hex: "#F5F5F9") ?? Color(uiColor: .systemGray6)
}

/// Обёртка контента строки в SwipeView с trailing actions (удаление, опционально — отметка возврата долга)
public struct SwipeableParticipantRow<Content: View>: View {
    let swipeEnabled: Bool
    let canDelete: Bool
    let paid: Bool
    let onDelete: () -> Void
    let onTogglePaid: (() -> Void)?
    @ViewBuilder let content: () -> Content

    public init(
        swipeEnabled: Bool = true,
        canDelete: Bool,
        paid: Bool = false,
        onDelete: @escaping () -> Void,
        onTogglePaid: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.swipeEnabled = swipeEnabled
        self.canDelete = canDelete
        self.paid = paid
        self.onDelete = onDelete
        self.onTogglePaid = onTogglePaid
        self.content = content
    }

    public var body: some View {
        Group {
            if swipeEnabled && canDelete {
                SwipeView {
                    content()
                        .contentShape(Rectangle())
                } trailingActions: { context in
                    if let onTogglePaid {
                        SwipeAction(action: {
                            onDelete()
                            context.state.wrappedValue = .closed
                        }) { _ in
                            swipeActionIcon("trash")
                        } background: { _ in
                            SwipeableColors.deleteBackground
                        }

                        SwipeAction(action: {
                            onTogglePaid()
                            context.state.wrappedValue = .closed
                        }) { _ in
                            swipeActionIcon(
                                paid ? "arrow.uturn.backward" : "checkmark",
                                isCheckmark: !paid
                            )
                        } background: { _ in
                            paid ? SwipeableColors.undoPaidBackground : SwipeableColors.markPaidBackground
                        }
                        .allowSwipeToTrigger()
                    } else {
                        SwipeAction(action: {
                            onDelete()
                            context.state.wrappedValue = .closed
                        }) { _ in
                            swipeActionIcon("trash")
                        } background: { _ in
                            SwipeableColors.deleteBackground
                        }
                        .allowSwipeToTrigger()
                    }
                }
                .swipeActionWidth(64)
                .swipeSpacing(14)
                .swipeActionCornerRadius(12)
                .swipeActionsVisibleStartPoint(20)
                .swipeActionsMaskCornerRadius(12)
                .swipeReadyToTriggerPadding(50)
                .swipeMinimumPointToTrigger(150)
            } else {
                content()
                    .contentShape(Rectangle())
            }
        }
    }
}
