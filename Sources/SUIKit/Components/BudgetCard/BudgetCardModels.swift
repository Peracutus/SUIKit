import Foundation

public enum BudgetCardPresentation: Sendable {
    case expanded
    case collapsed
}

/// Values are prepared and formatted by the owning feature, not calculated by SUIKit.
public struct BudgetBalanceCardData: Sendable {
    public let title: String
    public let amount: String
    public let subtitle: String
    public let incomeLabel: String
    public let incomeAmount: String
    public let expenseLabel: String
    public let expenseAmount: String
    public let progress: Double?
    public let progressLabel: String?
    public let period: PeriodSelection
    public let periodReferenceDate: Date
    public let periodCaption: String?
    public let periodAccessibilityTitle: String?
    public let isLoading: Bool

    public init(title: String, amount: String, subtitle: String, incomeLabel: String, incomeAmount: String, expenseLabel: String, expenseAmount: String, progress: Double?, progressLabel: String?, period: PeriodSelection, periodReferenceDate: Date = .now, periodCaption: String? = nil, periodAccessibilityTitle: String? = nil, isLoading: Bool = false) {
        self.title = title
        self.amount = amount
        self.subtitle = subtitle
        self.incomeLabel = incomeLabel
        self.incomeAmount = incomeAmount
        self.expenseLabel = expenseLabel
        self.expenseAmount = expenseAmount
        self.progress = progress
        self.progressLabel = progressLabel
        self.period = period
        self.periodReferenceDate = periodReferenceDate
        self.periodCaption = periodCaption
        self.periodAccessibilityTitle = periodAccessibilityTitle
        self.isLoading = isLoading
    }
}

public struct BudgetCardParticipant: Sendable {
    public let name: String
    public let avatarText: String
    public let amount: String

    public init(name: String, avatarText: String, amount: String) {
        self.name = name
        self.avatarText = avatarText
        self.amount = amount
    }
}

public struct BudgetSharedCardData: Sendable {
    public let title: String
    public let amount: String
    public let subtitle: String
    public let firstParticipant: BudgetCardParticipant
    public let secondParticipant: BudgetCardParticipant
    public let period: PeriodSelection

    public init(title: String, amount: String, subtitle: String, firstParticipant: BudgetCardParticipant, secondParticipant: BudgetCardParticipant, period: PeriodSelection) {
        self.title = title
        self.amount = amount
        self.subtitle = subtitle
        self.firstParticipant = firstParticipant
        self.secondParticipant = secondParticipant
        self.period = period
    }
}

public struct BudgetSavingsCardData: Sendable {
    public let title: String
    public let tag: String?
    public let amount: String
    public let subtitle: String
    public let goalLabel: String?
    public let progress: Double?
    public let progressLabel: String?
    public let savedLabel: String?
    public let remainingAmount: String?
    public let remainingLabel: String?
    public let emptyGoalLabel: String?

    public init(title: String, tag: String? = nil, amount: String, subtitle: String, goalLabel: String? = nil, progress: Double? = nil, progressLabel: String? = nil, savedLabel: String? = nil, remainingAmount: String? = nil, remainingLabel: String? = nil, emptyGoalLabel: String? = nil) {
        self.title = title
        self.tag = tag
        self.amount = amount
        self.subtitle = subtitle
        self.goalLabel = goalLabel
        self.progress = progress
        self.progressLabel = progressLabel
        self.savedLabel = savedLabel
        self.remainingAmount = remainingAmount
        self.remainingLabel = remainingLabel
        self.emptyGoalLabel = emptyGoalLabel
    }
}
