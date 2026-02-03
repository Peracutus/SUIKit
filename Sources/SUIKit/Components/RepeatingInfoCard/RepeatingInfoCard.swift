//
//  RepeatingInfoCard.swift
//  SUIKit
//
//  Переиспользуемая карточка для отображения ближайших платежей (по образцу repeatingInfoCard из TransactionDetailView)
//

import SwiftUI

/// Элемент списка: дата и отформатированная сумма
public struct RepeatingInfoCardItem: Identifiable {
    public let id = UUID()
    public let date: Date
    public let amountText: String

    public init(date: Date, amountText: String) {
        self.date = date
        self.amountText = amountText
    }
}

/// Карточка с заголовком и вертикальным списком платежей (дата + сумма)
public struct RepeatingInfoCard: View {
    let title: String
    let subtitle: String?
    let items: [RepeatingInfoCardItem]
    let formatDate: (Date) -> String
    let emptyText: String

    public init(
        title: String,
        subtitle: String? = nil,
        items: [RepeatingInfoCardItem],
        formatDate: @escaping (Date) -> String = { date in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM yyyy г."
            return formatter.string(from: date)
        },
        emptyText: String = "Нет предстоящих платежей"
    ) {
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.formatDate = formatDate
        self.emptyText = emptyText
    }

    private static let indexCircleColor = Color(hex: "#E4E4FB") ?? Color.purple.opacity(0.2)
    private static let indexTextColor = Color(hex: "#6E77DD") ?? .purple

    public var body: some View {
        PrimaryCard(useOptimizedShadow: true) {
            VStack(alignment: .leading) {
                CardHeaderTitle(
                    iconName: "repeat",
                    iconColor: .white,
                    title: title,
                    subtitle: subtitle ?? ""
                )

                if items.isEmpty {
                    Text(emptyText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                } else {
                    VStack(spacing: 5) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            rowView(index: index + 1, item: item)
                            if index < items.count - 1 {
                                Divider()
                                    .padding(.leading, 40)
                            }
                        }
                    }
                }
            }
        }
    }

    private func rowView(index: Int, item: RepeatingInfoCardItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Self.indexCircleColor)
                    .frame(width: 30, height: 30)
                Text("\(index)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Self.indexTextColor)
            }

            Text(formatDate(item.date))
                .font(.system(size: 16))
                .foregroundColor(.primary)

            Spacer()

            Text(item.amountText)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 8)
    }
}
