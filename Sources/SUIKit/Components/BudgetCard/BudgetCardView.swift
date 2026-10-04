import SwiftUI

/// Visual Budget Card variants. The Dashboard owns carousel gestures, collapse
/// progress, financial data, and publication of a confirmed period snapshot.
public struct BudgetCardView: View {
    private enum Content {
        case balance(BudgetBalanceCardData)
        case shared(BudgetSharedCardData)
        case savings(BudgetSavingsCardData)
    }

    private let content: Content
    private let presentation: BudgetCardPresentation
    private let calendar: Calendar
    private let locale: Locale
    private let onPeriodRequested: (PeriodSelection) -> Void
    @ScaledMetric(relativeTo: .largeTitle) private var heroFontSize: CGFloat = 30
    @ScaledMetric(relativeTo: .title2) private var collapsedAmountFontSize: CGFloat = 24
    @ScaledMetric(relativeTo: .subheadline) private var metricFontSize: CGFloat = 14
    @ScaledMetric(relativeTo: .caption2) private var smallFontSize: CGFloat = 10

    public init(
        balance: BudgetBalanceCardData,
        presentation: BudgetCardPresentation,
        calendar: Calendar = .current,
        locale: Locale = .current,
        onPeriodRequested: @escaping (PeriodSelection) -> Void
    ) {
        self.content = .balance(balance)
        self.presentation = presentation
        self.calendar = calendar
        self.locale = locale
        self.onPeriodRequested = onPeriodRequested
    }

    public init(
        shared: BudgetSharedCardData,
        presentation: BudgetCardPresentation,
        calendar: Calendar = .current,
        locale: Locale = .current,
        onPeriodRequested: @escaping (PeriodSelection) -> Void
    ) {
        self.content = .shared(shared)
        self.presentation = presentation
        self.calendar = calendar
        self.locale = locale
        self.onPeriodRequested = onPeriodRequested
    }

    public init(savings: BudgetSavingsCardData, presentation: BudgetCardPresentation) {
        self.content = .savings(savings)
        self.presentation = presentation
        self.calendar = .current
        self.locale = .current
        self.onPeriodRequested = { _ in }
    }

    public var body: some View {
        Group {
            switch presentation {
            case .expanded:
                expandedBody
            case .collapsed:
                collapsedBody
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var expandedBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch content {
            case let .balance(data):
                expandedBalance(data)
            case let .shared(data):
                expandedShared(data)
            case let .savings(data):
                expandedSavings(data)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 214, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground), in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(BudgetCardStyle.border, lineWidth: 1))
    }

    private var collapsedBody: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                switch content {
                case let .balance(data):
                    collapsedTitle(data.title, amount: data.amount)
                case let .shared(data):
                    collapsedTitle(data.title, amount: data.amount)
                case let .savings(data):
                    collapsedTitle(data.tag, amount: data.amount)
                }
            }
            Spacer(minLength: 0)
            switch content {
            case let .balance(data):
                periodSelector(data.period)
            case let .shared(data):
                periodSelector(data.period)
            case let .savings(data):
                Text(data.progressLabel)
                    .font(.system(.body, weight: .medium))
                    .foregroundStyle(BudgetCardStyle.green)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background {
            UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 3, y: 2)
        }
    }

    private func collapsedTitle(_ title: String, amount: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.caption, weight: .medium))
                .foregroundStyle(BudgetCardStyle.secondaryText)
                .lineLimit(1)
            Text(amount)
                .font(.system(size: collapsedAmountFontSize, weight: .bold))
                .foregroundStyle(BudgetCardStyle.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .accessibilityElement(children: .combine)
    }

    private func expandedBalance(_ data: BudgetBalanceCardData) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            header(title: data.title, period: data.period)
            HStack(alignment: .center, spacing: 8) {
                hero(amount: data.amount, subtitle: data.subtitle)
                Spacer(minLength: 0)
                BudgetRingProgress(progress: data.progress, label: data.progressLabel)
            }
            HStack(spacing: 12) {
                metricTile(label: data.incomeLabel, amount: data.incomeAmount, color: BudgetCardStyle.green, background: BudgetCardStyle.greenBackground)
                metricTile(label: data.expenseLabel, amount: data.expenseAmount, color: BudgetCardStyle.red, background: BudgetCardStyle.redBackground)
            }
        }
    }

    private func expandedShared(_ data: BudgetSharedCardData) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            header(title: data.title, period: data.period)
            hero(amount: data.amount, subtitle: data.subtitle)
                .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            HStack(spacing: 12) {
                participantTile(data.firstParticipant, color: BudgetCardStyle.blue, background: BudgetCardStyle.blueBackground)
                participantTile(data.secondParticipant, color: BudgetCardStyle.purple, background: BudgetCardStyle.purpleBackground)
            }
        }
    }

    private func expandedSavings(_ data: BudgetSavingsCardData) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 8) {
                cardTitle(data.title)
                Spacer(minLength: 0)
                Text(data.tag)
                    .font(.system(.caption, weight: .medium))
                    .foregroundStyle(BudgetCardStyle.savingsTagText)
                    .lineLimit(1)
                    .padding(.horizontal, 12)
                    .frame(minHeight: 30)
                    .background(BudgetCardStyle.savingsBackground, in: .rect(cornerRadius: 12))
            }
            HStack(alignment: .bottom, spacing: 8) {
                hero(amount: data.amount, subtitle: data.subtitle)
                Spacer(minLength: 0)
                Text(data.goalLabel)
                    .font(.system(size: smallFontSize))
                    .foregroundStyle(BudgetCardStyle.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)
            }
            .frame(minHeight: 55)
            ProgressTrack(progress: data.progress, color: BudgetCardStyle.savingsProgress, height: 6)
                .accessibilityLabel(data.savedLabel)
            HStack(spacing: 12) {
                savingsTile(value: data.progressLabel, label: data.savedLabel, color: BudgetCardStyle.green)
                savingsTile(value: data.remainingAmount, label: data.remainingLabel, color: BudgetCardStyle.primaryText)
            }
        }
    }

    private func header(title: String, period: PeriodSelection) -> some View {
        HStack(spacing: 8) {
            cardTitle(title)
            Spacer(minLength: 0)
            periodSelector(period)
        }
    }

    private func cardTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(.caption, weight: .medium))
            .foregroundStyle(BudgetCardStyle.secondaryText)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    private func periodSelector(_ period: PeriodSelection) -> some View {
        PeriodSelector(selection: period, calendar: calendar, locale: locale, onSelectionRequested: onPeriodRequested)
    }

    private func hero(amount: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(amount)
                .font(.system(size: heroFontSize, weight: .bold))
                .foregroundStyle(BudgetCardStyle.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(subtitle)
                .font(.system(size: smallFontSize))
                .foregroundStyle(BudgetCardStyle.secondaryText)
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
    }

    private func metricTile(label: String, amount: String, color: Color, background: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: smallFontSize))
            Text(amount)
                .font(.system(size: metricFontSize, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(color)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(.horizontal, 12)
        .background(background, in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }

    private func participantTile(_ participant: BudgetCardParticipant, color: Color, background: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 6) {
                InitialsBadge(name: participant.avatarText, color: color, size: 16, shape: .roundedRectangle(cornerRadius: 8), textSize: 10)
                Text(participant.name)
                    .font(.system(size: smallFontSize))
                    .lineLimit(1)
            }
            Text(participant.amount)
                .font(.system(size: metricFontSize, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(color)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(.horizontal, 12)
        .background(background, in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }

    private func savingsTile(value: String, label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: metricFontSize, weight: .medium))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(label)
                .font(.system(size: smallFontSize))
                .foregroundStyle(BudgetCardStyle.secondaryText)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(.horizontal, 12)
        .background(BudgetCardStyle.neutralTile, in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }
}

private struct BudgetRingProgress: View {
    let progress: Double
    let label: String
    @ScaledMetric(relativeTo: .caption2) private var labelFontSize: CGFloat = 11

    var body: some View {
        ZStack {
            Circle()
                .stroke(BudgetCardStyle.neutralTile, lineWidth: 6)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(BudgetCardStyle.savingsProgress, style: StrokeStyle(lineWidth: 6, lineCap: .butt))
                .rotationEffect(.degrees(-90))
            Text(label)
                .font(.system(size: labelFontSize, weight: .bold))
                .foregroundStyle(BudgetCardStyle.primaryText)
                .minimumScaleFactor(0.8)
        }
        .frame(width: 54, height: 54)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
    }
}
