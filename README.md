# SUIKit
## Design system for SwiftUI
This SPM contains lots of forms and designed components for my projects

## Period selector

`PeriodSelector` displays a confirmed `PeriodSelection` and requests changes from
its owner. Each card keeps its own selection; the control does not read financial
data or commit a new label ahead of the matching amounts.

```swift
PeriodSelector(selection: confirmedPeriod, calendar: calendar, locale: locale) { requested in
    // Load the requested period, then publish period and amounts together.
    requestPeriodChange(requested)
}
```

`PeriodSelection.interval(referenceDate:calendar:)` resolves dynamic presets to
full calendar periods. Manual ranges use `[start, endExclusive)`.
