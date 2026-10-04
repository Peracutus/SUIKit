import SwiftUI

private struct BudgetCardPreviewHost: View {
    @State private var balancePeriod: PeriodSelection = .currentMonth
    @State private var sharedPeriod: PeriodSelection = .currentMonth

    private let locale = Locale(identifier: "ru_RU")

    private var balance: BudgetBalanceCardData {
        BudgetBalanceCardData(
            title: "Баланс",
            amount: "1 740 000 ₽",
            subtitle: "Доступные средства",
            incomeLabel: "Доход",
            incomeAmount: "4 200 000 ₽",
            expenseLabel: "Расходы",
            expenseAmount: "2 460 000 ₽",
            progress: 0.41,
            progressLabel: "41%",
            period: balancePeriod
        )
    }

    private var shared: BudgetSharedCardData {
        BudgetSharedCardData(
            title: "Совместный бюджет",
            amount: "89 500 ₽",
            subtitle: "Общий баланс",
            firstParticipant: BudgetCardParticipant(name: "Ты", avatarText: "А", amount: "52 000 ₽"),
            secondParticipant: BudgetCardParticipant(name: "Партнёр", avatarText: "М", amount: "37 500 ₽"),
            period: sharedPeriod
        )
    }

    private let savings = BudgetSavingsCardData(
        title: "Накопление",
        tag: "Автомобиль",
        amount: "320 000 ₽",
        subtitle: "Накоплено",
        goalLabel: "Цель: 500 000 ₽",
        progress: 0.64,
        progressLabel: "64%",
        savedLabel: "Накоплено",
        remainingAmount: "180 000 ₽",
        remainingLabel: "Осталось накопить"
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BudgetCardView(balance: balance, presentation: .expanded, locale: locale) { balancePeriod = $0 }
                BudgetCardView(shared: shared, presentation: .expanded, locale: locale) { sharedPeriod = $0 }
                BudgetCardView(savings: savings, presentation: .expanded)
                BudgetCardView(balance: balance, presentation: .collapsed, locale: locale) { balancePeriod = $0 }
                BudgetCardView(shared: shared, presentation: .collapsed, locale: locale) { sharedPeriod = $0 }
                BudgetCardView(savings: savings, presentation: .collapsed)
            }
            .padding(20)
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

struct BudgetCardView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetCardPreviewHost()
            .previewDisplayName("Budget Card")
    }
}
