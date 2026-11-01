import SwiftUI

/// Draft editor for a fixed month or an inclusive day range.
struct PeriodPickerSheet: View {
    private enum Mode: Hashable { case month, range }

    let selection: PeriodSelection
    let referenceDate: Date
    let calendar: Calendar
    let locale: Locale
    let onApply: (PeriodSelection) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var mode: Mode
    @State private var selectedMonth: Date
    @State private var displayedMonth: Date
    @State private var rangeDraft: PeriodRangeDraft
    @State private var showsYearPicker = false
    @State private var yearCandidate: Date
    @State private var measuredContentHeight: CGFloat?
    @State private var measuredFooterHeight: CGFloat?
    @State private var isExpandedToLarge = false

    init(
        selection: PeriodSelection,
        referenceDate: Date,
        calendar: Calendar,
        locale: Locale,
        onApply: @escaping (PeriodSelection) -> Void
    ) {
        self.selection = selection
        self.referenceDate = referenceDate
        self.calendar = calendar
        self.locale = locale
        self.onApply = onApply

        let currentMonth = calendar.dateInterval(of: .month, for: referenceDate)?.start ?? referenceDate
        switch selection {
        case let .month(year, month):
            let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? currentMonth
            _mode = State(initialValue: .month)
            _selectedMonth = State(initialValue: date)
            _displayedMonth = State(initialValue: date)
            _rangeDraft = State(initialValue: PeriodRangeDraft())
            _yearCandidate = State(initialValue: date)
        case let .range(start, endExclusive):
            let lastDay = calendar.date(byAdding: .day, value: -1, to: endExclusive)
            let month = calendar.dateInterval(of: .month, for: start)?.start ?? currentMonth
            _mode = State(initialValue: .range)
            _selectedMonth = State(initialValue: month)
            _displayedMonth = State(initialValue: month)
            _rangeDraft = State(initialValue: PeriodRangeDraft(start: calendar.startOfDay(for: start), end: lastDay.map(calendar.startOfDay(for:))))
            _yearCandidate = State(initialValue: month)
        case .currentMonth, .currentYear:
            _mode = State(initialValue: .month)
            _selectedMonth = State(initialValue: currentMonth)
            _displayedMonth = State(initialValue: currentMonth)
            _rangeDraft = State(initialValue: PeriodRangeDraft())
            _yearCandidate = State(initialValue: currentMonth)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                Picker(PeriodSelectorText.sheetTitle(locale), selection: $mode) {
                    Text(PeriodSelectorText.month(locale)).tag(Mode.month)
                    Text(PeriodSelectorText.range(locale)).tag(Mode.range)
                }
                .pickerStyle(.segmented)
                .tint(PeriodSelectorStyle.accent)

                if mode == .month {
                    monthEditor
                } else {
                    rangeEditor
                }

                summary
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            .fixedSize(horizontal: false, vertical: true)
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(key: PeriodPickerContentHeightKey.self, value: proxy.size.height)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(PeriodSelectorText.apply(locale), action: apply)
                .font(.headline)
                .foregroundStyle(proposedSelection == nil ? SemanticColors.disabledText : SemanticColors.onAccent)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(proposedSelection == nil ? SemanticColors.disabledFill : PeriodSelectorStyle.accent, in: .rect(cornerRadius: 14))
                .disabled(proposedSelection == nil)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(SemanticColors.footer)
                .background {
                    GeometryReader { proxy in
                        Color.clear.preference(key: PeriodPickerFooterHeightKey.self, value: proxy.size.height)
                    }
                }
        }
        .background(SemanticColors.sheet)
        .foregroundStyle(SemanticColors.primaryText)
        .presentationBackground(SemanticColors.sheet)
        .environment(\.locale, locale)
        .environment(\.calendar, calendar)
        .onPreferenceChange(PeriodPickerContentHeightKey.self) { measuredContentHeight = $0 }
        .onPreferenceChange(PeriodPickerFooterHeightKey.self) { measuredFooterHeight = $0 }
        .presentationDetents([.height(sheetContentHeight), .large], selection: pickerDetent)
        .presentationDragIndicator(.visible)
        .onChange(of: mode) { oldMode, newMode in
            if oldMode == .month && newMode == .range {
                rangeDraft = PeriodRangeDraft()
                displayedMonth = selectedMonth
            }
        }
        .sheet(isPresented: $showsYearPicker) { yearPicker }
    }

    private var header: some View {
        HStack {
            Text(PeriodSelectorText.sheetTitle(locale))
                .font(.title3.bold())
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(PeriodSelectorStyle.secondaryText)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(PeriodSelectorText.close(locale))
        }
    }

    private var monthEditor: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text(PeriodSelectorText.year(locale))
                    .font(.subheadline)
                    .foregroundStyle(PeriodSelectorStyle.secondaryText)
                Spacer()
                Button {
                    yearCandidate = selectedMonth
                    showsYearPicker = true
                } label: {
                    HStack(spacing: 6) {
                        Text(String(calendar.component(.year, from: selectedMonth)))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .font(.subheadline)
                    .foregroundStyle(PeriodSelectorStyle.capsuleForeground)
                    .padding(.horizontal, 12)
                    .frame(minHeight: 44)
                    .background(PeriodSelectorStyle.capsuleBackground, in: .rect(cornerRadius: 12))
                }
                .accessibilityLabel(PeriodSelectorText.year(locale))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(1...12, id: \.self) { month in
                    let date = monthDate(year: calendar.component(.year, from: selectedMonth), month: month)
                    let isSelected = calendar.isDate(date, equalTo: selectedMonth, toGranularity: .month)
                    Button {
                        selectedMonth = date
                    } label: {
                        Text(monthName(for: date))
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(isSelected ? PeriodSelectorStyle.capsuleForeground : PeriodSelectorStyle.secondaryText)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(isSelected ? PeriodSelectorStyle.capsuleBackground : SemanticColors.sheet, in: .rect(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? PeriodSelectorStyle.accent : PeriodSelectorStyle.border))
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
    }

    private var yearPicker: some View {
        VStack(spacing: 16) {
            Text(PeriodSelectorText.year(locale)).font(.headline)
            DatePicker("", selection: $yearCandidate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
            Button(PeriodSelectorText.done(locale)) {
                let year = calendar.component(.year, from: yearCandidate)
                let month = calendar.component(.month, from: selectedMonth)
                selectedMonth = monthDate(year: year, month: month)
                showsYearPicker = false
            }
            .buttonStyle(.borderedProminent)
            .tint(PeriodSelectorStyle.accent)
        }
        .padding(20)
        .background(SemanticColors.sheet)
        .presentationBackground(SemanticColors.sheet)
        .presentationDetents([.medium])
    }

    private var rangeEditor: some View {
        VStack(spacing: 12) {
            HStack {
                Text(monthName(for: displayedMonth) + " " + String(calendar.component(.year, from: displayedMonth)))
                    .font(.subheadline)
                Spacer()
                monthNavigationButton(symbol: "chevron.left", label: PeriodSelectorText.previousMonth(locale), offset: -1)
                monthNavigationButton(symbol: "chevron.right", label: PeriodSelectorText.nextMonth(locale), offset: 1)
            }
            HStack(spacing: 4) {
                ForEach(weekdayNames, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundStyle(PeriodSelectorStyle.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(0..<calendarCellCount, id: \.self) { index in
                    calendarDay(at: index)
                }
            }
        }
        .padding(16)
        .background(SemanticColors.sheet, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(PeriodSelectorStyle.border))
    }

    private func monthNavigationButton(symbol: String, label: String, offset: Int) -> some View {
        Button {
            guard let next = calendar.date(byAdding: .month, value: offset, to: displayedMonth) else { return }
            displayedMonth = next
        } label: {
            Image(systemName: symbol)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(PeriodSelectorStyle.secondaryText)
                .frame(minWidth: 36, minHeight: 44)
                .background(PeriodSelectorStyle.controlBackground, in: .rect(cornerRadius: 8))
        }
        .accessibilityLabel(label)
    }

    private func calendarDay(at index: Int) -> some View {
        let date = calendar.date(byAdding: .day, value: index, to: firstVisibleDay) ?? firstVisibleDay
        let day = calendar.component(.day, from: date)
        let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
        let isBoundary = rangeDraft.start.map { calendar.isDate($0, inSameDayAs: date) } == true
            || rangeDraft.end.map { calendar.isDate($0, inSameDayAs: date) } == true
        let isInside = rangeDraft.start.map { date >= $0 } == true && rangeDraft.end.map { date <= $0 } == true

        return Button {
            chooseRangeDay(date)
        } label: {
            Text(String(day))
                .font(.system(.caption))
                .foregroundStyle(isBoundary ? SemanticColors.onAccent : isInside ? PeriodSelectorStyle.capsuleForeground : isCurrentMonth ? Color.primary : PeriodSelectorStyle.secondaryText.opacity(0.65))
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(isBoundary ? PeriodSelectorStyle.accent : isInside ? PeriodSelectorStyle.capsuleBackground : .clear, in: .rect(cornerRadius: 6))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(date, format: .dateTime.day().month(.wide).year()))
        .accessibilityAddTraits(isInside ? .isSelected : [])
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(PeriodSelectorText.selectedPeriod(locale))
                .font(.subheadline)
                .foregroundStyle(PeriodSelectorStyle.secondaryText)
            if let proposedSelection {
                Text(proposedSelection.accessibilityTitle(referenceDate: referenceDate, calendar: calendar, locale: locale))
                    .font(.subheadline)
            } else {
                Text(" ").font(.subheadline)
            }
        }
    }

    private var proposedSelection: PeriodSelection? {
        switch mode {
        case .month:
            return .month(year: calendar.component(.year, from: selectedMonth), month: calendar.component(.month, from: selectedMonth))
        case .range:
            return rangeDraft.selection(calendar: calendar)
        }
    }

    private var sheetContentHeight: CGFloat {
        let contentHeight = measuredContentHeight ?? estimatedContentHeight
        let footerHeight = measuredFooterHeight ?? 70
        return ceil(contentHeight + footerHeight)
    }

    private var estimatedContentHeight: CGFloat {
        switch mode {
        case .month:
            return 434
        case .range:
            let rows = CGFloat(calendarCellCount / 7)
            return 224 + 32 + rows * 44 + 44 + 60
        }
    }

    private var pickerDetent: Binding<PresentationDetent> {
        Binding(
            get: { isExpandedToLarge ? .large : .height(sheetContentHeight) },
            set: { isExpandedToLarge = ($0 == .large) }
        )
    }

    private func apply() {
        guard let proposedSelection else { return }
        onApply(proposedSelection)
    }

    private func chooseRangeDay(_ date: Date) {
        rangeDraft.select(date, calendar: calendar)
    }

    private var firstVisibleDay: Date {
        let monthStart = calendar.dateInterval(of: .month, for: displayedMonth)?.start ?? displayedMonth
        let weekday = calendar.component(.weekday, from: monthStart)
        let offset = (weekday - calendar.firstWeekday + 7) % 7
        return calendar.date(byAdding: .day, value: -offset, to: monthStart) ?? monthStart
    }

    private var calendarCellCount: Int {
        let monthDays = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 31
        let leading = calendar.dateComponents([.day], from: firstVisibleDay, to: calendar.dateInterval(of: .month, for: displayedMonth)?.start ?? displayedMonth).day ?? 0
        return ((leading + monthDays + 6) / 7) * 7
    }

    private var weekdayNames: [String] {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        let symbols = formatter.shortStandaloneWeekdaySymbols ?? formatter.shortWeekdaySymbols ?? []
        guard symbols.count == 7 else { return [] }
        let first = calendar.firstWeekday - 1
        return Array(symbols[first...]) + Array(symbols[..<first])
    }

    private func monthDate(year: Int, month: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? selectedMonth
    }

    private func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.dateFormat = "LLLL"
        return formatter.string(from: date).capitalized(with: locale)
    }

}

private struct PeriodPickerContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}

private struct PeriodPickerFooterHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}
