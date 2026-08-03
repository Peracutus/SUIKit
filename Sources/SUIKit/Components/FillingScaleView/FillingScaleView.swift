//
//  FillingScaleView.swift
//  SUIKit
//
//  Шкала заполнения: оплачено / долг
//

import SwiftUI

// MARK: - Constants

private enum FillingScaleLayout {
    static let filledColor = Color(hex: "#87BD00") ?? .green
    static let unfilledColor = Color(hex: "#ACACAC")?.opacity(0.15) ?? .gray.opacity(0.15)
    static let barHeight: CGFloat = 8
    static let labelFontSize: CGFloat = 12
}

// MARK: - FillingScaleView

/// Переиспользуемая шкала заполнения (оплачено / долг)
public struct FillingScaleView: View {
    let paidAmount: Decimal
    let debtAmount: Decimal
    let formatAmount: (Decimal) -> String

    public init(
        paidAmount: Decimal,
        debtAmount: Decimal,
        formatAmount: @escaping (Decimal) -> String
    ) {
        self.paidAmount = paidAmount
        self.debtAmount = debtAmount
        self.formatAmount = formatAmount
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            progressBar
            labelsRow
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            let total = paidAmount + debtAmount
            let paid = NSDecimalNumber(decimal: paidAmount).doubleValue
            let totalVal = NSDecimalNumber(decimal: total).doubleValue
            let progress: CGFloat = totalVal > 0 ? CGFloat(paid / totalVal) : 0
            let filledWidth = max(0, min(1, progress)) * geo.size.width

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: FillingScaleLayout.barHeight / 2)
                    .fill(FillingScaleLayout.unfilledColor)
                    .frame(height: FillingScaleLayout.barHeight)

                if filledWidth > 0 {
                    RoundedRectangle(cornerRadius: FillingScaleLayout.barHeight / 2)
                        .fill(FillingScaleLayout.filledColor)
                        .frame(width: filledWidth, height: FillingScaleLayout.barHeight)
                }
            }
        }
        .frame(height: FillingScaleLayout.barHeight)
    }

    private var labelsRow: some View {
        HStack {
            Text("\(formatAmount(paidAmount)) оплачено")
                .font(.system(size: FillingScaleLayout.labelFontSize, weight: .regular))
                .foregroundColor(FillingScaleLayout.filledColor)

            Spacer()

            Text("\(formatAmount(debtAmount)) долг")
                .font(.system(size: FillingScaleLayout.labelFontSize, weight: .regular))
                .foregroundColor(.gray)
        }
    }
}
