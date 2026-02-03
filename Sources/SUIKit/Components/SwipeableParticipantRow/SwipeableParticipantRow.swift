//
//  SwipeableParticipantRow.swift
//  SUIKit
//
//  Переиспользуемая строка участника со свайпом на удаление (SwipeView)
//

import SwiftUI
import SwipeActions

/// Цвета для свайп-действия (дублируют AppColors.Swipeable для SUIKit)
private enum SwipeableColors {
    static let swipeBackground = Color(hex: "#E6E6FFA6") ?? Color.purple.opacity(0.15)
    static let deleteIcon = Color(hex: "#DE4D5D") ?? .red
    static var deleteCircle: Color { (Color(hex: "#DE4D5D") ?? .red).opacity(0.3) }
}

/// Обёртка контента строки в SwipeView с trailing delete-действием
public struct SwipeableParticipantRow<Content: View>: View {
    let swipeEnabled: Bool
    let canDelete: Bool
    let onDelete: () -> Void
    @ViewBuilder let content: () -> Content

    public init(
        swipeEnabled: Bool = true,
        canDelete: Bool,
        onDelete: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.swipeEnabled = swipeEnabled
        self.canDelete = canDelete
        self.onDelete = onDelete
        self.content = content
    }

    public var body: some View {
        Group {
            if swipeEnabled && canDelete {
                SwipeView {
                    content()
                        .contentShape(Rectangle())
                } trailingActions: { _ in
                    SwipeAction(action: onDelete) { _ in
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(SwipeableColors.deleteIcon)
                    } background: { _ in
                        SwipeableColors.swipeBackground
                    }
                    .allowSwipeToTrigger()
                }
                .swipeActionWidth(80)
                .swipeActionsMaskCornerRadius(12)
                .swipeMinimumPointToTrigger(200)
            } else {
                content()
                    .contentShape(Rectangle())
            }
        }
    }
}
