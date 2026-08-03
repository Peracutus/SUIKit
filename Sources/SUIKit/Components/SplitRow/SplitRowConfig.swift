//
//  SplitRowConfig.swift
//  SUIKit
//
//  Конфиги для унифицированной строки участника/группы (SplitRowView)
//

import SwiftUI

// MARK: - SplitRowContent

/// Тип контента строки: участник или группа
public enum SplitRowContent {
    case participant(ParticipantRowConfig)
    case group(GroupRowConfig)
}

// MARK: - ParticipantRowConfig

/// Конфиг строки участника (сумма, статус оплаты, редактирование)
public struct ParticipantRowConfig {
    public var id: UUID
    public var name: String
    public var avatarColor: String
    public var amountText: String?
    public var amountStrikethrough: Bool = false
    /// Когда задан — сумма отображается этим цветом (напр. .gray для карточки «Я»)
    public var amountColor: Color? = nil
    public var paid: Bool = false
    public var isMe: Bool = false
    public var showPaidCheckbox: Bool = true
    public var nameEditable: Bool = false
    public var amountEditable: Bool = false

    public var onRowTap: (() -> Void)?
    public var onNameTap: (() -> Void)?
    public var onNameSubmit: (() -> Void)?
    public var onAmountTap: (() -> Void)?
    public var onAmountSubmit: (() -> Void)?
    public var onTogglePaid: (() -> Void)?

    public var isEditingName: Bool = false
    public var editingName: Binding<String>?
    public var isEditingAmount: Bool = false
    public var editingAmount: Binding<String>?

    public init(
        id: UUID,
        name: String,
        avatarColor: String,
        amountText: String? = nil,
        amountStrikethrough: Bool = false,
        amountColor: Color? = nil,
        paid: Bool = false,
        isMe: Bool = false,
        showPaidCheckbox: Bool = true,
        nameEditable: Bool = false,
        amountEditable: Bool = false,
        onRowTap: (() -> Void)? = nil,
        onNameTap: (() -> Void)? = nil,
        onNameSubmit: (() -> Void)? = nil,
        onAmountTap: (() -> Void)? = nil,
        onAmountSubmit: (() -> Void)? = nil,
        onTogglePaid: (() -> Void)? = nil,
        isEditingName: Bool = false,
        editingName: Binding<String>? = nil,
        isEditingAmount: Bool = false,
        editingAmount: Binding<String>? = nil
    ) {
        self.id = id
        self.name = name
        self.avatarColor = avatarColor
        self.amountText = amountText
        self.amountStrikethrough = amountStrikethrough
        self.amountColor = amountColor
        self.paid = paid
        self.isMe = isMe
        self.showPaidCheckbox = showPaidCheckbox
        self.nameEditable = nameEditable
        self.amountEditable = amountEditable
        self.onRowTap = onRowTap
        self.onNameTap = onNameTap
        self.onNameSubmit = onNameSubmit
        self.onAmountTap = onAmountTap
        self.onAmountSubmit = onAmountSubmit
        self.onTogglePaid = onTogglePaid
        self.isEditingName = isEditingName
        self.editingName = editingName
        self.isEditingAmount = isEditingAmount
        self.editingAmount = editingAmount
    }
}

// MARK: - GroupRowConfig

/// Конфиг строки группы (emoji, количество участников, аватары)
public struct GroupRowConfig {
    public var id: UUID
    public var name: String
    public var emoji: String
    public var avatarColor: String
    public var participantCount: Int
    /// Массив (name, color) для overlapping кружков 20x20, макс 4 видимых + "+N"
    public var participantAvatars: [(name: String, color: String)]
    /// true — бордер 1px #6E77DD (выбранная группа)
    public var isSelected: Bool

    public init(
        id: UUID,
        name: String,
        emoji: String = "👥",
        avatarColor: String = "#6E77DD",
        participantCount: Int,
        participantAvatars: [(name: String, color: String)] = [],
        isSelected: Bool = false
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.avatarColor = avatarColor
        self.participantCount = participantCount
        self.participantAvatars = participantAvatars
        self.isSelected = isSelected
    }
}
