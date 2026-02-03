//
//  SplitRowView.swift
//  SUIKit
//
//  Унифицированная карточка участника или группы для Split
//

import SwiftUI
import UIKit

// MARK: - Constants

private enum SplitRowLayout {
    static let participantHeight: CGFloat = 64
    static let groupHeight: CGFloat = 80
    static let avatarSizeParticipant: CGFloat = 40
    static let avatarSizeGroup: CGFloat = 48
    static let participantCircleSize: CGFloat = 20
    static let participantCircleOverlap: CGFloat = -5
    static let maxVisibleAvatars = 4
    static let checkmarkSize: CGFloat = 18
    static let amountCheckmarkSpacing: CGFloat = 15
    static let leadingPadding: CGFloat = 16
    /// Отступ от правого края карточки до checkmark
    static let trailingPadding: CGFloat = 26
    static let activeColor = Color(hex: "#6E77DD") ?? .purple
}

// MARK: - SplitRowView

public struct SplitRowView: View {
    let content: SplitRowContent
    let isCardPresentation: Bool

    public init(content: SplitRowContent, isCardPresentation: Bool = true) {
        self.content = content
        self.isCardPresentation = isCardPresentation
    }

    public var body: some View {
        switch content {
        case .participant(let config):
            participantRow(config: config)
        case .group(let config):
            groupRow(config: config)
        }
    }

    // MARK: - Participant Row (64pt)

    private func participantRow(config: ParticipantRowConfig) -> some View {
        HStack(alignment: .center, spacing: 12) {
            leftPart(config: config)
            Spacer()
            rightPart(config: config)
        }
        .frame(height: SplitRowLayout.participantHeight)
        .padding(.leading, isCardPresentation ? SplitRowLayout.leadingPadding : 0)
        .padding(.trailing, isCardPresentation ? SplitRowLayout.trailingPadding : 0)
        .background(Color.white)
        .modifier(ConditionalCardPresentationModifier(isActive: isCardPresentation))
    }

    /// Левая область (аватар + имя): тап открывает Историю долгов
    @ViewBuilder
    private func leftPart(config: ParticipantRowConfig) -> some View {
        let leftContent = HStack(spacing: 12) {
            AvatarView(
                content: .initials(name: config.name),
                colorHex: config.avatarColor,
                size: SplitRowLayout.avatarSizeParticipant
            )
            VStack(alignment: .leading, spacing: 4) {
                nameView(config: config)
            }
        }
        .contentShape(Rectangle())

        if let onRowTap = config.onRowTap {
            Button(action: onRowTap) { leftContent }
                .buttonStyle(.plain)
        } else {
            leftContent
        }
    }

    /// Правая область (сумма + чекмарк): в read-only режиме тап переключает isPaid
    @ViewBuilder
    private func rightPart(config: ParticipantRowConfig) -> some View {
        let rightAreaTappable = !config.amountEditable && config.onTogglePaid != nil
        let rightContent = HStack(spacing: SplitRowLayout.amountCheckmarkSpacing) {
            if let amountText = config.amountText {
                amountView(config: config, amountText: amountText)
            }
            if config.showPaidCheckbox {
                checkmarkView(config: config, embeddedInRightAreaTap: rightAreaTappable)
            }
        }
        .contentShape(Rectangle())

        if rightAreaTappable, let onTogglePaid = config.onTogglePaid {
            Button(action: onTogglePaid) { rightContent }
                .buttonStyle(.plain)
        } else {
            rightContent
        }
    }

    @ViewBuilder
    private func checkmarkView(config: ParticipantRowConfig, embeddedInRightAreaTap: Bool = false) -> some View {
        let size = SplitRowLayout.checkmarkSize
        let isPaid = config.paid
        let mark = Group {
            if isPaid {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: size))
                    .foregroundColor(.green)
            } else {
                Circle()
                    .stroke(SplitRowLayout.activeColor, lineWidth: 1)
                    .frame(width: size, height: size)
            }
        }
        .frame(width: size, height: size)
        .animation(.easeInOut(duration: 0.25), value: config.paid)

        if config.onTogglePaid != nil, !embeddedInRightAreaTap {
            Button(action: { config.onTogglePaid?() }) {
                mark
            }
            .buttonStyle(.plain)
        } else {
            mark
        }
    }

    @ViewBuilder
    private func nameView(config: ParticipantRowConfig) -> some View {
        if config.isMe {
            Text(config.name)
                .participantNameStyle()
        } else if config.isEditingName, let binding = config.editingName {
            TextField("Имя участника", text: binding)
                .participantNameStyle()
                .textFieldStyle(.plain)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "#6E77DD") ?? .purple, lineWidth: 1)
                )
                .onSubmit { config.onNameSubmit?() }
        } else {
            Text(config.name)
                .participantNameStyle()
                .onTapGesture { config.onNameTap?() }
        }
    }

    @ViewBuilder
    private func amountView(config: ParticipantRowConfig, amountText: String) -> some View {
        Group {
            if config.amountEditable, config.isEditingAmount, let binding = config.editingAmount {
                TextField("Сумма", text: binding)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#6E77DD") ?? .purple, lineWidth: 1)
                    )
                    .onSubmit { config.onAmountSubmit?() }
            } else {
                let amountLabel = Text(amountText)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(config.amountColor ?? .primary)
                    .strikethrough(config.amountColor == nil && (config.paid || config.amountStrikethrough))
                    .animation(.easeInOut(duration: 0.25), value: config.paid)
                if config.amountEditable, config.onAmountTap != nil {
                    amountLabel.onTapGesture { config.onAmountTap?() }
                } else {
                    amountLabel
                }
            }
        }
        .frame(minWidth: 60)
    }

    // MARK: - Group Row (80pt)

    private func groupRow(config: GroupRowConfig) -> some View {
        HStack(spacing: 12) {
            AvatarView(
                content: .emoji(config.emoji),
                colorHex: config.avatarColor,
                size: SplitRowLayout.avatarSizeGroup
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(config.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text("\(config.participantCount) участников")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }

            Spacer()

            participantCirclesStack(avatars: config.participantAvatars, total: config.participantCount)
        }
        .frame(height: SplitRowLayout.groupHeight)
        .padding(.leading, isCardPresentation ? SplitRowLayout.leadingPadding : 0)
        .padding(.trailing, isCardPresentation ? SplitRowLayout.trailingPadding : 0)
        .background(Color.white)
        .modifier(ConditionalCardPresentationModifier(isActive: isCardPresentation))
        .overlay(
            RoundedRectangle(cornerRadius: isCardPresentation ? AppRadius.medium : 0)
                .stroke(config.isSelected ? SplitRowLayout.activeColor : Color.clear, lineWidth: config.isSelected ? 1 : 0)
        )
    }

    private func participantCirclesStack(avatars: [(name: String, color: String)], total: Int) -> some View {
        let displayCount = min(avatars.count, SplitRowLayout.maxVisibleAvatars)
        let showPlusN = total > SplitRowLayout.maxVisibleAvatars
        let remainder = showPlusN ? total - SplitRowLayout.maxVisibleAvatars : 0

        return HStack(spacing: SplitRowLayout.participantCircleOverlap) {
            ForEach(Array(avatars.prefix(displayCount).enumerated()), id: \.offset) { _, item in
                AvatarView(
                    content: .initials(name: item.name),
                    colorHex: item.color,
                    size: SplitRowLayout.participantCircleSize
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            }

            if showPlusN {
                ZStack {
                    Circle()
                        .fill(Color(uiColor: .systemGray5))
                    Text("+\(remainder)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.primary)
                }
                .frame(width: SplitRowLayout.participantCircleSize, height: SplitRowLayout.participantCircleSize)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            }
        }
    }
}

// MARK: - Conditional Card Style

private struct ConditionalCardPresentationModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        if isActive {
            content
                .cornerRadius(AppRadius.medium)
                .optimizedShadow()
        } else {
            content
        }
    }
}
