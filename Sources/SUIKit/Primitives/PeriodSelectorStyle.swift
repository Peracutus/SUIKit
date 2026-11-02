import SwiftUI

/// Semantic colors for the period controls, based on the Open Money design system.
enum PeriodSelectorStyle {
    static let accent = SemanticColors.accent
    static let capsuleBackground = SemanticColors.selectedFill
    static let capsuleForeground = SemanticColors.selectedText
    static let secondaryText = SemanticColors.secondaryText
    static let border = SemanticColors.separator
    static let controlBackground = SemanticColors.controlFill
    static let menuBackground = SemanticColors.sheet
    static let menuText = SemanticColors.primaryText
    static let menuShadow = Color.black.opacity(0.15)
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
