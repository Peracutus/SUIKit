import Foundation
import XCTest
@testable import SUIKit

final class PeriodSelectionTests: XCTestCase {
    private var calendar: Calendar {
        var value = Calendar(identifier: .gregorian)
        value.locale = Locale(identifier: "ru_RU")
        value.timeZone = TimeZone(identifier: "Europe/Moscow")!
        value.firstWeekday = 2
        return value
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    func testPresetsUseFullCalendarIntervalsAndFollowReferenceDate() {
        let october = PeriodSelection.currentMonth.interval(referenceDate: date(2026, 10, 4), calendar: calendar)
        XCTAssertEqual(october?.start, date(2026, 10, 1))
        XCTAssertEqual(october?.end, date(2026, 11, 1))
        XCTAssertEqual(PeriodSelection.currentMonth.interval(referenceDate: date(2026, 11, 4), calendar: calendar)?.start, date(2026, 11, 1))

        let year = PeriodSelection.currentYear.interval(referenceDate: date(2026, 10, 4), calendar: calendar)
        XCTAssertEqual(year?.start, date(2026, 1, 1))
        XCTAssertEqual(year?.end, date(2027, 1, 1))
    }

    func testManualMonthDoesNotMoveWithReferenceDate() {
        let selection = PeriodSelection.month(year: 2025, month: 8)
        XCTAssertEqual(selection.interval(referenceDate: date(2026, 10, 4), calendar: calendar)?.start, date(2025, 8, 1))
        XCTAssertEqual(selection.interval(referenceDate: date(2027, 1, 1), calendar: calendar)?.start, date(2025, 8, 1))
        XCTAssertNil(PeriodSelection.month(year: 2025, month: 13).interval(referenceDate: date(2026, 10, 4), calendar: calendar))
    }

    func testRussianCapsuleLabels() {
        let now = date(2026, 10, 4)
        let locale = Locale(identifier: "ru_RU")
        XCTAssertEqual(PeriodSelection.currentMonth.capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "Октябрь")
        XCTAssertEqual(PeriodSelection.month(year: 2025, month: 8).capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "авг. 2025")
        XCTAssertEqual(PeriodSelection.currentYear.capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "2026 год")
        XCTAssertEqual(PeriodSelection.range(start: date(2026, 10, 1), endExclusive: date(2026, 10, 16)).capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "1–15 окт.")
        XCTAssertEqual(PeriodSelection.range(start: date(2026, 9, 28), endExclusive: date(2026, 10, 6)).capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "28 сен. – 5 окт.")
    }

    func testCrossYearAndVoiceOverLabels() {
        let now = date(2026, 10, 4)
        let locale = Locale(identifier: "ru_RU")
        let selection = PeriodSelection.range(start: date(2025, 12, 28), endExclusive: date(2026, 1, 6))
        XCTAssertEqual(selection.capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "28 дек. 2025 – 5 янв. 2026")
        XCTAssertEqual(selection.accessibilityTitle(referenceDate: now, calendar: calendar, locale: locale), "28 декабря 2025 – 5 января 2026")
    }

    func testEnglishLabelsAndInvalidRange() {
        let now = date(2026, 10, 4)
        let locale = Locale(identifier: "en_US")
        XCTAssertEqual(PeriodSelection.currentMonth.capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "October")
        XCTAssertEqual(PeriodSelection.currentYear.capsuleTitle(referenceDate: now, calendar: calendar, locale: locale), "2026")
        XCTAssertNil(PeriodSelection.range(start: date(2026, 10, 16), endExclusive: date(2026, 10, 16)).interval(referenceDate: now, calendar: calendar))
    }

    func testRangeDraftNeedsConfirmationAndSupportsOneDay() {
        var draft = PeriodRangeDraft()
        draft.select(date(2026, 10, 15), calendar: calendar)
        XCTAssertNil(draft.selection(calendar: calendar))
        draft.select(date(2026, 10, 15), calendar: calendar)
        XCTAssertEqual(draft.selection(calendar: calendar), .range(start: date(2026, 10, 15), endExclusive: date(2026, 10, 16)))
    }

    func testEarlierAndThirdTapsStartNewRange() {
        var draft = PeriodRangeDraft()
        draft.select(date(2026, 10, 15), calendar: calendar)
        draft.select(date(2026, 10, 1), calendar: calendar)
        XCTAssertEqual(draft.start, date(2026, 10, 1))
        XCTAssertNil(draft.end)
        draft.select(date(2026, 10, 5), calendar: calendar)
        draft.select(date(2026, 10, 20), calendar: calendar)
        XCTAssertEqual(draft.start, date(2026, 10, 20))
        XCTAssertNil(draft.end)
    }
}
