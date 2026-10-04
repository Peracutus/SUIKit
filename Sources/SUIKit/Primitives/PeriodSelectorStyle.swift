import SwiftUI

/// Semantic colors for the period controls, based on the Open Money design system.
enum PeriodSelectorStyle {
    static let accent = Color(hex: "#6E77DD") ?? .indigo
    static let capsuleBackground = Color(hex: "#F0EFFB") ?? .indigo.opacity(0.09)
    static let capsuleForeground = Color(hex: "#5551A4") ?? .indigo
    static let secondaryText = Color(hex: "#667085") ?? .secondary
    static let border = Color(hex: "#E5E7EB") ?? .gray.opacity(0.2)
    static let controlBackground = Color(hex: "#F0F0F5") ?? .gray.opacity(0.1)
}

enum PeriodSelectorText {
    static func currentMonth(_ locale: Locale) -> String { russian(locale) ? "Текущий месяц" : "Current month" }
    static func currentYear(_ locale: Locale) -> String { russian(locale) ? "Текущий год" : "Current year" }
    static func choosePeriod(_ locale: Locale) -> String { russian(locale) ? "Выбрать период…" : "Choose period…" }
    static func sheetTitle(_ locale: Locale) -> String { russian(locale) ? "Выбрать период" : "Choose period" }
    static func month(_ locale: Locale) -> String { russian(locale) ? "Месяц" : "Month" }
    static func range(_ locale: Locale) -> String { russian(locale) ? "Диапазон" : "Range" }
    static func year(_ locale: Locale) -> String { russian(locale) ? "Год" : "Year" }
    static func selectedPeriod(_ locale: Locale) -> String { russian(locale) ? "Выбранный период" : "Selected period" }
    static func apply(_ locale: Locale) -> String { russian(locale) ? "Применить" : "Apply" }
    static func done(_ locale: Locale) -> String { russian(locale) ? "Готово" : "Done" }
    static func close(_ locale: Locale) -> String { russian(locale) ? "Закрыть" : "Close" }
    static func previousMonth(_ locale: Locale) -> String { russian(locale) ? "Предыдущий месяц" : "Previous month" }
    static func nextMonth(_ locale: Locale) -> String { russian(locale) ? "Следующий месяц" : "Next month" }

    private static func russian(_ locale: Locale) -> Bool { locale.language.languageCode?.identifier == "ru" }
}
