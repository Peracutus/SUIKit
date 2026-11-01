import SwiftUI

public struct TransactionRow: View, Equatable {
    public let model: TransactionRowModel
    public let onTransactionTap: ((UUID) -> Void)?
    public let onDelete: ((UUID) -> Void)?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var swipeOffset: CGFloat = 0
    @State private var isDeleteRevealed = false

    public init(
        model: TransactionRowModel,
        onTransactionTap: ((UUID) -> Void)? = nil,
        onDelete: ((UUID) -> Void)? = nil
    ) {
        self.model = model
        self.onTransactionTap = onTransactionTap
        self.onDelete = onDelete
    }

    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.model == rhs.model }

    public var body: some View {
        ZStack(alignment: .trailing) {
            if let onDelete {
                Button(role: .destructive) {
                    closeSwipe()
                    onDelete(model.id)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 72)
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Удалить")
            }

            rowContent
                .frame(maxWidth: .infinity)
                .background(DashboardListStyle.card)
                .offset(x: swipeOffset)
                .simultaneousGesture(horizontalSwipe)
        }
        .frame(minHeight: 68)
    }

    private var horizontalSwipe: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard onDelete != nil,
                      abs(value.translation.width) > abs(value.translation.height) * 1.25 else { return }
                let origin: CGFloat = isDeleteRevealed ? -72 : 0
                swipeOffset = min(0, max(-160, origin + value.translation.width))
            }
            .onEnded { value in
                guard onDelete != nil else { return }
                switch TransactionRowSwipeOutcome.resolve(
                    translation: value.translation,
                    predictedEndTranslation: value.predictedEndTranslation,
                    wasRevealed: isDeleteRevealed
                ) {
                case .delete:
                    closeSwipe()
                    onDelete?(model.id)
                case .closed:
                    closeSwipe()
                case .revealed:
                    isDeleteRevealed = true
                    animateSwipe { swipeOffset = -72 }
                }
            }
    }

    private func closeSwipe() {
        isDeleteRevealed = false
        animateSwipe { swipeOffset = 0 }
    }

    private func animateSwipe(_ changes: () -> Void) {
        if reduceMotion { changes() }
        else { withAnimation(.easeOut(duration: 0.2), changes) }
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(model.iconColor.opacity(0.14))
                model.iconName.image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(model.iconColor)
            }
            .frame(width: 40, height: 40)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.system(size: 15))
                    .foregroundStyle(DashboardListStyle.primaryText)
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                Text(model.subtitle?.isEmpty == false ? model.subtitle! : " ")
                    .font(.system(size: 13))
                    .foregroundStyle(DashboardListStyle.secondaryText)
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                    .accessibilityHidden(model.subtitle?.isEmpty != false)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 4) {
                Text(model.amount)
                    .font(.system(size: 15))
                    .foregroundStyle(model.transactionType == .income ? DashboardListStyle.income : DashboardListStyle.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                HStack(spacing: 6) {
                    if model.isRegular { marker("repeat") }
                    if model.isSplit { marker("scissors") }
                }
                .frame(height: 22, alignment: .topTrailing)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 18)
        .frame(minHeight: 68)
        .contentShape(Rectangle())
        .onTapGesture {
            if isDeleteRevealed { closeSwipe() }
            else { onTransactionTap?(model.id) }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityAddTraits(onTransactionTap != nil ? .isButton : [])
        .accessibilityActions {
            if let onTransactionTap {
                Button("Открыть детали") { onTransactionTap(model.id) }
            }
            if let onDelete {
                Button("Удалить", role: .destructive) { onDelete(model.id) }
            }
        }
    }

    private func marker(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(DashboardListStyle.secondaryText)
            .frame(width: 22, height: 22)
    }

    private var accessibilityDescription: String {
        [model.title, model.subtitle, model.amount,
         model.transactionType == .income ? "Доход" : "Расход",
         model.isRegular ? "Регулярная" : nil,
         model.isSplit ? "Сплит" : nil]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
