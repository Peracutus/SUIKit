import SwiftUI

/// A presentational selector. Its owner commits a requested selection together
/// with the matching financial snapshot; this view never fetches data.
public struct PeriodSelector: View {
    public let selection: PeriodSelection
    public let calendar: Calendar
    public let locale: Locale
    public let onSelectionRequested: (PeriodSelection) -> Void

    @State private var showsPicker = false

    public init(
        selection: PeriodSelection,
        calendar: Calendar = .current,
        locale: Locale = .current,
        onSelectionRequested: @escaping (PeriodSelection) -> Void
    ) {
        self.selection = selection
        self.calendar = calendar
        self.locale = locale
        self.onSelectionRequested = onSelectionRequested
    }

    public var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            Menu {
                presetButton(.currentMonth, title: PeriodSelectorText.currentMonth(locale))
                presetButton(.currentYear, title: PeriodSelectorText.currentYear(locale))
                Divider()
                Button(PeriodSelectorText.choosePeriod(locale)) {
                    showsPicker = true
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selection.capsuleTitle(referenceDate: context.date, calendar: calendar, locale: locale))
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .accessibilityHidden(true)
                }
                .font(.system(.caption, design: .default, weight: .medium))
                .foregroundStyle(PeriodSelectorStyle.capsuleForeground)
                .padding(.horizontal, 12)
                .frame(minHeight: 30)
                .background(PeriodSelectorStyle.capsuleBackground, in: .rect(cornerRadius: 12))
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
                .accessibilityLabel(PeriodSelectorText.selectedPeriod(locale))
                .accessibilityValue(selection.accessibilityTitle(referenceDate: context.date, calendar: calendar, locale: locale))
            }
        }
        .sheet(isPresented: $showsPicker) {
            PeriodPickerSheet(
                selection: selection,
                referenceDate: .now,
                calendar: calendar,
                locale: locale
            ) { requested in
                showsPicker = false
                if requested != selection {
                    onSelectionRequested(requested)
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    private func presetButton(_ preset: PeriodSelection, title: String) -> some View {
        Button {
            guard preset != selection else { return }
            onSelectionRequested(preset)
        } label: {
            if preset == selection {
                Label(title, systemImage: "checkmark")
            } else {
                Text(title)
            }
        }
    }
}
