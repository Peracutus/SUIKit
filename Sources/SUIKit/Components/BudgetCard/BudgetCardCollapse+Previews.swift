import SwiftUI

/// Scrub the whole collapse without the dashboard's scroll snapping so that
/// intermediate surfaces and the status-bar boundary can be inspected.
private struct BudgetCardCollapsePreview: View {
    @State private var progress: Double = 1

    private let balance = BudgetBalanceCardData(
        title: "Баланс",
        amount: "125 400 ₽",
        subtitle: "Баланс за период",
        incomeLabel: "Доход",
        incomeAmount: "150 000 ₽",
        expenseLabel: "Расходы",
        expenseAmount: "24 600 ₽",
        progress: nil,
        progressLabel: nil,
        period: .currentMonth
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                DashboardListStyle.canvas
                BudgetCardView(
                    balance: balance,
                    presentation: .expanded,
                    collapseProgress: progress
                )
                .frame(height: 150 + 70 * progress)
                .background { DashboardListStyle.canvas }
                .padding(.horizontal, 16 * progress)
                .offset(y: (geometry.safeAreaInsets.top + 15) * progress)

                VStack(spacing: 20) {
                    Spacer()
                    Text("Переход карточки")
                    Slider(value: $progress, in: 0...1)
                        .accessibilityIdentifier("collapse.preview.progress")
                    HStack {
                        ForEach([0.0, 0.1, 0.5, 1.0], id: \.self) { value in
                            Button("\(Int(value * 100))%") { progress = value }
                        }
                    }
                    Button("Плавный переход") {
                        withAnimation(.linear(duration: 3)) {
                            progress = progress < 0.5 ? 1 : 0
                        }
                    }
                }
                .padding(24)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(DashboardListStyle.canvas)
    }
}

#Preview("Budget Collapse · Dark") {
    BudgetCardCollapsePreview().preferredColorScheme(.dark)
}

#Preview("Budget Collapse · Light") {
    BudgetCardCollapsePreview().preferredColorScheme(.light)
}
