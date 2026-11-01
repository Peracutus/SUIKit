import Foundation

struct PeriodRangeDraft: Equatable {
    private(set) var start: Date?
    private(set) var end: Date?

    init(start: Date? = nil, end: Date? = nil) {
        self.start = start
        self.end = end
    }

    mutating func select(_ date: Date, calendar: Calendar) {
        let day = calendar.startOfDay(for: date)
        if start == nil || end != nil || (start.map { day < $0 } == true) {
            start = day
            end = nil
        } else {
            end = day
        }
    }

    func selection(calendar: Calendar) -> PeriodSelection? {
        guard let start, let end,
              let endExclusive = calendar.date(byAdding: .day, value: 1, to: end)
        else { return nil }
        return .range(start: start, endExclusive: endExclusive)
    }
}
