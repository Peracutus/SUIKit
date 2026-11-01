import Foundation

/// A period chosen for one card. Presets are resolved against the supplied date,
/// while a manually chosen month or range remains fixed.
public enum PeriodSelection: Hashable, Sendable {
    case currentMonth
    case currentYear
    case month(year: Int, month: Int)
    case range(start: Date, endExclusive: Date)

    public func interval(referenceDate: Date, calendar: Calendar) -> DateInterval? {
        switch self {
        case .currentMonth:
            return calendar.dateInterval(of: .month, for: referenceDate)
        case .currentYear:
            return calendar.dateInterval(of: .year, for: referenceDate)
        case let .month(year, month):
            guard (1...12).contains(month),
                  let date = calendar.date(from: DateComponents(year: year, month: month, day: 1))
            else { return nil }
            return calendar.dateInterval(of: .month, for: date)
        case let .range(start, endExclusive):
            guard start < endExclusive else { return nil }
            return DateInterval(start: start, end: endExclusive)
        }
    }

    public func capsuleTitle(referenceDate: Date, calendar: Calendar, locale: Locale) -> String {
        switch self {
        case .currentMonth:
            return Self.monthTitle(for: referenceDate, referenceDate: referenceDate, calendar: calendar, locale: locale)
        case .currentYear:
            return Self.yearTitle(calendar.component(.year, from: referenceDate), locale: locale)
        case let .month(year, month):
            guard let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else { return "" }
            return Self.monthTitle(for: date, referenceDate: referenceDate, calendar: calendar, locale: locale)
        case let .range(start, endExclusive):
            guard let lastDay = calendar.date(byAdding: .day, value: -1, to: endExclusive), start <= lastDay else { return "" }
            let sameMonth = calendar.isDate(start, equalTo: lastDay, toGranularity: .month)
            let sameYear = calendar.isDate(start, equalTo: lastDay, toGranularity: .year)
            let currentYear = calendar.component(.year, from: referenceDate)
            let endYear = calendar.component(.year, from: lastDay)
            let startDay = calendar.component(.day, from: start)
            if sameMonth {
                let month = Self.shortMonth(for: start, locale: locale, calendar: calendar)
                let suffix = endYear == currentYear ? "" : " \(endYear)"
                let endDay = calendar.component(.day, from: lastDay)
                return startDay == endDay ? "\(startDay) \(month)\(suffix)" : "\(startDay)–\(endDay) \(month)\(suffix)"
            }
            let includeBothYears = !sameYear
            let startLabel = "\(startDay) \(Self.shortMonth(for: start, locale: locale, calendar: calendar))" + (includeBothYears ? " \(calendar.component(.year, from: start))" : "")
            let endLabel = "\(calendar.component(.day, from: lastDay)) \(Self.shortMonth(for: lastDay, locale: locale, calendar: calendar))" + (includeBothYears || endYear != currentYear ? " \(endYear)" : "")
            return "\(startLabel) – \(endLabel)"
        }
    }

    public func accessibilityTitle(referenceDate: Date, calendar: Calendar, locale: Locale) -> String {
        guard let interval = interval(referenceDate: referenceDate, calendar: calendar),
              let lastDay = calendar.date(byAdding: .day, value: -1, to: interval.end)
        else { return capsuleTitle(referenceDate: referenceDate, calendar: calendar, locale: locale) }
        let first = Self.formatted(interval.start, format: "d MMMM yyyy", locale: locale, calendar: calendar)
        let last = Self.formatted(lastDay, format: "d MMMM yyyy", locale: locale, calendar: calendar)
        return first == last ? first : "\(first) – \(last)"
    }

    private static func monthTitle(for date: Date, referenceDate: Date, calendar: Calendar, locale: Locale) -> String {
        if calendar.isDate(date, equalTo: referenceDate, toGranularity: .year) {
            return formatted(date, format: "LLLL", locale: locale, calendar: calendar).capitalized(with: locale)
        }
        return "\(shortMonth(for: date, locale: locale, calendar: calendar)) \(calendar.component(.year, from: date))"
    }

    private static func yearTitle(_ year: Int, locale: Locale) -> String {
        locale.language.languageCode?.identifier == "ru" ? "\(year) год" : "\(year)"
    }

    private static func shortMonth(for date: Date, locale: Locale, calendar: Calendar) -> String {
        // The design uses «сен.»; Foundation's Russian abbreviated month is «сент.».
        if locale.language.languageCode?.identifier == "ru", calendar.component(.month, from: date) == 9 {
            return "сен."
        }
        return formatted(date, format: "LLL", locale: locale, calendar: calendar)
    }

    private static func formatted(_ date: Date, format: String, locale: Locale, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
