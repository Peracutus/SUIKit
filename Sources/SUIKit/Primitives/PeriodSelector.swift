import SwiftUI
import UIKit

/// A presentational selector. Its owner commits a requested selection together
/// with the matching financial snapshot; this view never fetches data.
public struct PeriodSelector: View {
    public let selection: PeriodSelection
    public let calendar: Calendar
    public let locale: Locale
    public let referenceDate: Date?
    public let onSelectionRequested: (PeriodSelection) -> Void

    @State private var showsPicker = false
    @State private var showsMenu = false
    @State private var anchorView: UIView?
    @State private var dropdown: PeriodSelectorDropdown?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        selection: PeriodSelection,
        calendar: Calendar = .current,
        locale: Locale = .current,
        referenceDate: Date? = nil,
        onSelectionRequested: @escaping (PeriodSelection) -> Void
    ) {
        self.selection = selection
        self.calendar = calendar
        self.locale = locale
        self.referenceDate = referenceDate
        self.onSelectionRequested = onSelectionRequested
    }

    public var body: some View {
        Group {
            if let referenceDate {
                menu(referenceDate: referenceDate)
            } else {
                TimelineView(.periodic(from: .now, by: 60)) { context in
                    menu(referenceDate: context.date)
                }
            }
        }
        .sheet(isPresented: $showsPicker) {
            PeriodPickerSheet(
                selection: selection,
                referenceDate: referenceDate ?? .now,
                calendar: calendar,
                locale: locale
            ) { requested in
                showsPicker = false
                if requested != selection {
                    onSelectionRequested(requested)
                }
            }
            .presentationDragIndicator(.visible)
        }
        .onDisappear { dismissMenu(animated: false) }
    }

    private func menu(referenceDate: Date) -> some View {
        Button {
            if showsMenu {
                dismissMenu()
            } else {
                presentMenu(referenceDate: referenceDate)
            }
        } label: {
            HStack(spacing: 6) {
                Text(selection.capsuleTitle(referenceDate: referenceDate, calendar: calendar, locale: locale))
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .rotationEffect(.degrees(showsMenu ? 180 : 0))
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.18), value: showsMenu)
                    .accessibilityHidden(true)
            }
            .font(.system(.caption, design: .default, weight: .medium))
            .foregroundStyle(PeriodSelectorStyle.capsuleForeground)
            .padding(.horizontal, 12)
            .frame(minHeight: 30)
            .background(PeriodSelectorStyle.capsuleBackground, in: .rect(cornerRadius: 12))
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("period.selector")
        .background(PeriodSelectorAnchorView { anchorView = $0 })
        .accessibilityLabel(PeriodSelectorText.selectedPeriod(locale))
        .accessibilityValue(selection.accessibilityTitle(referenceDate: referenceDate, calendar: calendar, locale: locale))
    }

    private func presentMenu(referenceDate: Date) {
        guard let anchorView, anchorView.window != nil else { return }
        let presented = PeriodSelectorDropdown()
        presented.show(anchorView: anchorView) {
            PeriodSelectorDropdownMenu(
                selection: selection,
                referenceDate: referenceDate,
                calendar: calendar,
                locale: locale,
                onPreset: { requested in
                    dismissMenu()
                    if requested != selection { onSelectionRequested(requested) }
                },
                onChoosePeriod: {
                    dismissMenu()
                    showsPicker = true
                }
            )
        } onDismiss: {
            dismissMenu()
        }
        dropdown = presented
        showsMenu = true
    }

    private func dismissMenu(animated: Bool = true) {
        dropdown?.dismiss(animated: animated)
        dropdown = nil
        showsMenu = false
    }
}
