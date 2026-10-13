import SwiftUI

private struct PeriodSelectorPreviewHost: View {
    @State private var balance: PeriodSelection = .currentMonth
    @State private var shared: PeriodSelection = .currentYear

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.firstWeekday = 2
        return calendar
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Баланс")
                Spacer()
                PeriodSelector(selection: balance, calendar: calendar, locale: calendar.locale ?? .current) {
                    balance = $0
                }
            }
            HStack {
                Text("Совместный бюджет")
                Spacer()
                PeriodSelector(selection: shared, calendar: calendar, locale: calendar.locale ?? .current) {
                    shared = $0
                }
            }
        }
        .padding(20)
        .background(Color(uiColor: .systemBackground), in: .rect(cornerRadius: 16))
        .padding()
    }
}

struct PeriodSelector_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PeriodSelectorPreviewHost()
                .previewDisplayName("Period Selector")
            PeriodSelectorDropdownMenu(
                selection: .currentMonth,
                referenceDate: .now,
                calendar: Calendar(identifier: .gregorian),
                locale: Locale(identifier: "ru_RU"),
                onPreset: { _ in },
                onChoosePeriod: {}
            )
            .frame(width: 248)
            .padding(24)
            .previewDisplayName("Period Menu")
            PeriodPickerSheet(
                selection: .currentMonth,
                referenceDate: .now,
                calendar: Calendar(identifier: .gregorian),
                locale: Locale(identifier: "ru_RU"),
                onApply: { _ in }
            )
            .previewDisplayName("Period Picker")
        }
    }
}
