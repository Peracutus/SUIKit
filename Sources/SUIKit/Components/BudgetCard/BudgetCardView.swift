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
    private let collapseProgress: CGFloat?
    private let transitionPlaceholder: Bool
    private let calendar: Calendar
    private let locale: Locale
    private let onPeriodRequested: ((PeriodSelection) -> Void)?
    @ScaledMetric(relativeTo: .largeTitle) private var heroFontSize: CGFloat = 30
    @ScaledMetric(relativeTo: .title2) private var collapsedAmountFontSize: CGFloat = 24
    @ScaledMetric(relativeTo: .subheadline) private var metricFontSize: CGFloat = 14
    @ScaledMetric(relativeTo: .caption2) private var smallFontSize: CGFloat = 10

    public init(
        balance: BudgetBalanceCardData,
        presentation: BudgetCardPresentation,
        collapseProgress: CGFloat? = nil,
        calendar: Calendar = .current,
        locale: Locale = .current,
        onPeriodRequested: ((PeriodSelection) -> Void)? = nil
    ) {
        self.content = .balance(balance)
        self.presentation = presentation
        self.collapseProgress = collapseProgress
        self.transitionPlaceholder = false
        self.calendar = calendar
        self.locale = locale
        self.onPeriodRequested = onPeriodRequested
    }

    public init(
        shared: BudgetSharedCardData,
        presentation: BudgetCardPresentation,
        collapseProgress: CGFloat? = nil,
        calendar: Calendar = .current,
        locale: Locale = .current,
        onPeriodRequested: ((PeriodSelection) -> Void)? = nil
    ) {
        self.content = .shared(shared)
        self.presentation = presentation
        self.collapseProgress = collapseProgress
        self.transitionPlaceholder = false
        self.calendar = calendar
        self.locale = locale
        self.onPeriodRequested = onPeriodRequested
    }

    public init(savings: BudgetSavingsCardData, presentation: BudgetCardPresentation, collapseProgress: CGFloat? = nil) {
        self.content = .savings(savings)
        self.presentation = presentation
        self.collapseProgress = collapseProgress
        self.transitionPlaceholder = false
        self.calendar = .current
        self.locale = .current
        self.onPeriodRequested = { _ in }
    }

    public var body: some View {
        Group {
            if let collapseProgress {
                transitionBody(progress: collapseProgress)
            } else {
                switch presentation {
                case .expanded:
                    expandedBody
                case .collapsed:
                    collapsedBody
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private init(content: Content, presentation: BudgetCardPresentation, calendar: Calendar, locale: Locale, onPeriodRequested: ((PeriodSelection) -> Void)?, transitionPlaceholder: Bool) {
        self.content = content
        self.presentation = presentation
        self.collapseProgress = nil
        self.transitionPlaceholder = transitionPlaceholder
        self.calendar = calendar
        self.locale = locale
        self.onPeriodRequested = onPeriodRequested
    }

    private func transitionBody(progress rawProgress: CGFloat) -> some View {
        let progress = min(max(rawProgress, 0), 1)
        let surface = UnevenRoundedRectangle(
            topLeadingRadius: 16 * progress,
            bottomLeadingRadius: 16,
            bottomTrailingRadius: 16,
            topTrailingRadius: 16 * progress
        )
        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                BudgetCardView(
                    content: content,
                    presentation: .expanded,
                    calendar: calendar,
                    locale: locale,
                    onPeriodRequested: onPeriodRequested,
                    transitionPlaceholder: true
                )
                .opacity(progress)
                .allowsHitTesting(false)
                .accessibilityHidden(progress <= 0.5)

                BudgetCardView(
                    content: content,
                    presentation: .collapsed,
                    calendar: calendar,
                    locale: locale,
                    onPeriodRequested: onPeriodRequested,
                    transitionPlaceholder: true
                )
                .opacity(1 - progress)
                .allowsHitTesting(false)
                .accessibilityHidden(progress > 0.5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            .overlayPreferenceValue(BudgetCardTransitionAnchorKey.self) { anchors in
                GeometryReader { proxy in
                    if let expanded = anchors[.expandedTitle],
                       let collapsed = anchors[.collapsedTitle] {
                        let rect = motionRect(from: proxy[collapsed], to: proxy[expanded], progress: progress)
                        movingTitle
                            .frame(width: rect.width, height: rect.height, alignment: .leading)
                            .position(rect.center)
                    }
                    if let expanded = anchors[.expandedAmount],
                       let collapsed = anchors[.collapsedAmount] {
                        let rect = motionRect(from: proxy[collapsed], to: proxy[expanded], progress: progress)
                        let leadingX: CGFloat = {
                            guard let expandedTitle = anchors[.expandedTitle],
                                  let collapsedTitle = anchors[.collapsedTitle] else { return rect.minX }
                            return motionRect(from: proxy[collapsedTitle], to: proxy[expandedTitle], progress: progress).minX
                        }()
                        let scale = (collapsedAmountFontSize + (heroFontSize - collapsedAmountFontSize) * progress) / heroFontSize
                        Color.clear
                            .overlay(alignment: .topLeading) {
                                movingAmount
                                    .scaleEffect(scale, anchor: .topLeading)
                                    .offset(x: leadingX, y: rect.minY)
                            }
                            .allowsHitTesting(false)
                    }
                    if let expanded = anchors[.expandedPeriod],
                       let collapsed = anchors[.collapsedPeriod] {
                        let rect = motionRect(from: proxy[collapsed], to: proxy[expanded], progress: progress)
                        movingPeriod
                            .frame(width: rect.width, height: rect.height, alignment: .trailing)
                            .position(rect.center)
                    }
                }
            }
            // Crossfade content only. One opaque surface owns the corners and
            // border throughout the transition, including the status-bar area.
            .background(Color(uiColor: .systemBackground), in: surface)
            .clipShape(surface)
            .overlay {
                BudgetCardCollapseUpperBorder(progress: progress)
                    .stroke(BudgetCardStyle.border, lineWidth: 1)
                    .opacity(progress)
                BudgetCardBottomBorder(radius: 15.5)
                    .stroke(BudgetCardStyle.border, lineWidth: 1)
            }
        }
    }

    private var movingAmount: some View {
        let amount: String
        switch content {
        case let .balance(data): amount = data.amount
        case let .shared(data): amount = data.amount
        case let .savings(data): amount = data.amount
        }
        return Text(amount)
            .font(.system(size: heroFontSize, weight: .bold))
            .foregroundStyle(BudgetCardStyle.primaryText)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .contentTransition(.numericText())
            .accessibilityLabel(amount)
    }

    private var movingTitle: some View {
        let title: String
        switch content {
        case let .balance(data): title = data.title
        case let .shared(data): title = data.title
        case let .savings(data): title = data.title
        }
        return Text(title)
            .font(.system(.caption, weight: .medium))
            .foregroundStyle(BudgetCardStyle.secondaryText)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    private var movesTitle: Bool {
        switch content {
        case .balance, .shared: true
        case .savings: false
        }
    }

    @ViewBuilder
    private var movingPeriod: some View {
        switch content {
        case let .balance(data):
            periodSelector(data.period, referenceDate: data.periodReferenceDate, caption: data.periodCaption, accessibilityTitle: data.periodAccessibilityTitle)
        case let .shared(data):
            periodSelector(data.period, referenceDate: .now)
        case .savings:
            EmptyView()
        }
    }

    private func motionRect(from start: CGRect, to end: CGRect, progress: CGFloat) -> CGRect {
        // During collapse, vertical movement starts immediately. Horizontal
        // movement follows later and eases into the compact position.
        let horizontalPhase = min(max(progress / 0.65, 0), 1)
        let horizontalProgress = horizontalPhase * horizontalPhase * (3 - 2 * horizontalPhase)
        return CGRect(
            x: start.minX + (end.minX - start.minX) * horizontalProgress,
            y: start.minY + (end.minY - start.minY) * progress,
            width: start.width + (end.width - start.width) * progress,
            height: start.height + (end.height - start.height) * progress
        )
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
        .background {
            if !transitionPlaceholder {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .systemBackground))
            }
        }
        .overlay {
            if !transitionPlaceholder {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(BudgetCardStyle.border, lineWidth: 1)
            }
        }
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
                    collapsedTitle(data.tag ?? data.title, amount: data.amount)
                }
            }
            Spacer(minLength: 0)
            switch content {
            case let .balance(data):
                periodSelector(data.period, referenceDate: data.periodReferenceDate, caption: data.periodCaption, accessibilityTitle: data.periodAccessibilityTitle)
            case let .shared(data):
                periodSelector(data.period, referenceDate: .now)
            case let .savings(data):
                if let progressLabel = data.progressLabel {
                    Text(progressLabel)
                        .font(.system(.body, weight: .medium))
                        .foregroundStyle(BudgetCardStyle.green)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background {
            if !transitionPlaceholder {
                UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(0.04), radius: 3, y: 2)
            }
        }
        .overlay {
            if !transitionPlaceholder {
                BudgetCardBottomBorder(radius: 16)
                    .stroke(BudgetCardStyle.border, lineWidth: 1)
            }
        }
    }

    private func collapsedTitle(_ title: String, amount: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.caption, weight: .medium))
                .foregroundStyle(BudgetCardStyle.secondaryText)
                .lineLimit(1)
                .anchorPreference(key: BudgetCardTransitionAnchorKey.self, value: .bounds) {
                    transitionPlaceholder && movesTitle ? [.collapsedTitle: $0] : [:]
                }
                .opacity(transitionPlaceholder && movesTitle ? 0 : 1)
                .accessibilityHidden(transitionPlaceholder && movesTitle)
            Text(amount)
                .font(.system(size: collapsedAmountFontSize, weight: .bold))
                .foregroundStyle(BudgetCardStyle.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .anchorPreference(key: BudgetCardTransitionAnchorKey.self, value: .bounds) {
                    transitionPlaceholder ? [.collapsedAmount: $0] : [:]
                }
                .opacity(transitionPlaceholder ? 0 : 1)
        }
        .accessibilityElement(children: .combine)
    }

    private func expandedBalance(_ data: BudgetBalanceCardData) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            header(title: data.title, period: data.period, referenceDate: data.periodReferenceDate, caption: data.periodCaption, accessibilityTitle: data.periodAccessibilityTitle)
            HStack(alignment: .center, spacing: 8) {
                hero(amount: data.amount, subtitle: data.subtitle)
                Spacer(minLength: 0)
                if let progress = data.progress, let progressLabel = data.progressLabel {
                    BudgetRingProgress(progress: progress, label: progressLabel)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if data.isLoading {
                    ProgressView()
                        .controlSize(.mini)
                        .accessibilityLabel("Обновление данных")
                }
            }
            HStack(spacing: 12) {
                metricTile(label: data.incomeLabel, amount: data.incomeAmount, color: BudgetCardStyle.green, background: BudgetCardStyle.greenBackground)
                metricTile(label: data.expenseLabel, amount: data.expenseAmount, color: BudgetCardStyle.red, background: BudgetCardStyle.redBackground)
            }
        }
    }

    private func expandedShared(_ data: BudgetSharedCardData) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            header(title: data.title, period: data.period, referenceDate: .now)
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
                if let tag = data.tag {
                    Text(tag)
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(BudgetCardStyle.savingsTagText)
                        .lineLimit(1)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 30)
                        .background(BudgetCardStyle.savingsBackground, in: .rect(cornerRadius: 12))
                }
            }
            HStack(alignment: .bottom, spacing: 8) {
                hero(amount: data.amount, subtitle: data.subtitle)
                Spacer(minLength: 0)
                if let goalLabel = data.goalLabel {
                    Text(goalLabel)
                        .font(.system(size: smallFontSize))
                        .foregroundStyle(BudgetCardStyle.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                }
            }
            .frame(minHeight: 55)
            if let progress = data.progress,
               let progressLabel = data.progressLabel,
               let savedLabel = data.savedLabel,
               let remainingAmount = data.remainingAmount,
               let remainingLabel = data.remainingLabel {
                ProgressTrack(progress: progress, color: BudgetCardStyle.savingsProgress, height: 6)
                    .accessibilityLabel(savedLabel)
                HStack(spacing: 12) {
                    savingsTile(value: progressLabel, label: savedLabel, color: BudgetCardStyle.green)
                    savingsTile(value: remainingAmount, label: remainingLabel, color: BudgetCardStyle.primaryText)
                }
            } else if let emptyGoalLabel = data.emptyGoalLabel {
                Text(emptyGoalLabel)
                    .font(.system(.caption))
                    .foregroundStyle(BudgetCardStyle.secondaryText)
                    .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                    .padding(.horizontal, 12)
                    .background(BudgetCardStyle.neutralTile, in: .rect(cornerRadius: 14))
            }
        }
    }

    private func header(title: String, period: PeriodSelection, referenceDate: Date, caption: String? = nil, accessibilityTitle: String? = nil) -> some View {
        HStack(spacing: 8) {
            cardTitle(title)
            Spacer(minLength: 0)
            periodSelector(period, referenceDate: referenceDate, caption: caption, accessibilityTitle: accessibilityTitle)
        }
    }

    private func cardTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(.caption, weight: .medium))
            .foregroundStyle(BudgetCardStyle.secondaryText)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .anchorPreference(key: BudgetCardTransitionAnchorKey.self, value: .bounds) {
                transitionPlaceholder && movesTitle ? [.expandedTitle: $0] : [:]
            }
            .opacity(transitionPlaceholder && movesTitle ? 0 : 1)
            .accessibilityHidden(transitionPlaceholder && movesTitle)
    }

    @ViewBuilder
    private func periodSelector(_ period: PeriodSelection, referenceDate: Date, caption: String? = nil, accessibilityTitle: String? = nil) -> some View {
        Group {
            if let onPeriodRequested {
                PeriodSelector(selection: period, calendar: calendar, locale: locale, referenceDate: referenceDate, onSelectionRequested: onPeriodRequested)
            } else {
                periodCaption(caption ?? period.capsuleTitle(referenceDate: referenceDate, calendar: calendar, locale: locale))
                    .accessibilityLabel(accessibilityTitle ?? period.accessibilityTitle(referenceDate: referenceDate, calendar: calendar, locale: locale))
            }
        }
        .anchorPreference(key: BudgetCardTransitionAnchorKey.self, value: .bounds) {
            transitionPlaceholder ? [presentation == .expanded ? .expandedPeriod : .collapsedPeriod: $0] : [:]
        }
        .opacity(transitionPlaceholder ? 0 : 1)
        .allowsHitTesting(!transitionPlaceholder)
        .accessibilityHidden(transitionPlaceholder)
    }

    private func periodCaption(_ title: String) -> some View {
        Text(title)
            .font(.system(.caption, weight: .medium))
            .foregroundStyle(PeriodSelectorStyle.capsuleForeground)
            .padding(.horizontal, 12)
            .frame(minHeight: 30)
            .background(PeriodSelectorStyle.capsuleBackground, in: .rect(cornerRadius: 12))
            .frame(minHeight: 44)
    }

    private func hero(amount: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(amount)
                .font(.system(size: heroFontSize, weight: .bold))
                .foregroundStyle(BudgetCardStyle.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .anchorPreference(key: BudgetCardTransitionAnchorKey.self, value: .bounds) {
                    transitionPlaceholder ? [.expandedAmount: $0] : [:]
                }
                .opacity(transitionPlaceholder ? 0 : 1)
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

private struct BudgetCardBottomBorder: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let inset: CGFloat = 0.5
        let bottom = rect.maxY - inset
        let left = rect.minX + inset
        let right = rect.maxX - inset
        let corner = min(radius, (right - left) / 2)
        var path = Path()
        path.move(to: CGPoint(x: left, y: bottom - corner))
        path.addQuadCurve(to: CGPoint(x: left + corner, y: bottom), control: CGPoint(x: left, y: bottom))
        path.addLine(to: CGPoint(x: right - corner, y: bottom))
        path.addQuadCurve(to: CGPoint(x: right, y: bottom - corner), control: CGPoint(x: right, y: bottom))
        return path
    }
}

private enum BudgetCardTransitionAnchor: Hashable {
    case expandedTitle
    case collapsedTitle
    case expandedAmount
    case collapsedAmount
    case expandedPeriod
    case collapsedPeriod
}

private struct BudgetCardTransitionAnchorKey: PreferenceKey {
    static let defaultValue: [BudgetCardTransitionAnchor: Anchor<CGRect>] = [:]

    static func reduce(value: inout [BudgetCardTransitionAnchor: Anchor<CGRect>], nextValue: () -> [BudgetCardTransitionAnchor: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { _, latest in latest })
    }
}

private extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
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
