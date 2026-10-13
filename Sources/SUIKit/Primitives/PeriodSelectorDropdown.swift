import SwiftUI
import UIKit

/// Supplies the actual window and frame of the capsule. The dropdown is drawn
/// above the card's clipped, scrolling header without changing its layout.
struct PeriodSelectorAnchorView: UIViewRepresentable {
    let onReady: (UIView) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async { onReady(view) }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

@MainActor
final class PeriodSelectorDropdown {
    private var window: UIWindow?
    private let motion = PeriodSelectorDropdownMotion()
    private var dismissalTask: Task<Void, Never>?

    func show<Content: View>(
        anchorView: UIView,
        @ViewBuilder content: () -> Content,
        onDismiss: @escaping () -> Void
    ) {
        guard let scene = anchorView.window?.windowScene else { return }
        let frame = anchorView.convert(anchorView.bounds, to: nil)
        let overlay = PeriodSelectorDropdownOverlay(anchor: frame, motion: motion, onDismiss: onDismiss, content: content())
        let controller = UIHostingController(rootView: overlay)
        controller.view.backgroundColor = .clear
        controller.view.accessibilityViewIsModal = true

        let window = UIWindow(windowScene: scene)
        window.frame = scene.coordinateSpace.bounds
        window.windowLevel = .normal + 1
        window.backgroundColor = .clear
        window.rootViewController = controller
        window.isHidden = false
        self.window = window
    }

    func dismiss(animated: Bool = true) {
        guard window != nil else { return }
        dismissalTask?.cancel()
        if animated && !UIAccessibility.isReduceMotionEnabled {
            withAnimation(.easeIn(duration: 0.14)) { motion.isVisible = false }
            dismissalTask = Task { [self] in
                try? await Task.sleep(for: .milliseconds(150))
                guard !Task.isCancelled else { return }
                removeWindow()
            }
        } else {
            removeWindow()
        }
    }

    private func removeWindow() {
        window?.isHidden = true
        window?.rootViewController = nil
        window = nil
    }
}

@MainActor
private final class PeriodSelectorDropdownMotion: ObservableObject {
    @Published var isVisible = false
}

private struct PeriodSelectorDropdownOverlay<Content: View>: View {
    let anchor: CGRect
    @ObservedObject var motion: PeriodSelectorDropdownMotion
    let onDismiss: () -> Void
    let content: Content

    @State private var menuHeight: CGFloat = 157

    var body: some View {
        GeometryReader { geometry in
            let width = min(248, geometry.size.width - 24)
            let x = min(max(anchor.maxX - width, 12), geometry.size.width - width - 12)
            let proposedY = anchor.maxY + 1
            let y = proposedY + menuHeight + 12 <= geometry.size.height
                ? proposedY
                : max(12, anchor.minY - menuHeight - 1)

            ZStack(alignment: .topLeading) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)

                content
                    .frame(width: width)
                    .background {
                        GeometryReader { proxy in
                            Color.clear.preference(key: PeriodMenuHeightKey.self, value: proxy.size.height)
                        }
                    }
                    .scaleEffect(motion.isVisible ? 1 : 0.97, anchor: .topTrailing)
                    .opacity(motion.isVisible ? 1 : 0)
                    .offset(x: x, y: y + (motion.isVisible ? 0 : -5))
            }
            .onPreferenceChange(PeriodMenuHeightKey.self) { menuHeight = $0 }
        }
        .ignoresSafeArea()
        .accessibilityAction(named: "Close", onDismiss)
        .onAppear {
            if UIAccessibility.isReduceMotionEnabled {
                motion.isVisible = true
            } else {
                withAnimation(.easeOut(duration: 0.2)) { motion.isVisible = true }
            }
        }
    }
}

private struct PeriodMenuHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 157
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

struct PeriodSelectorDropdownMenu: View {
    let selection: PeriodSelection
    let referenceDate: Date
    let calendar: Calendar
    let locale: Locale
    let onPreset: (PeriodSelection) -> Void
    let onChoosePeriod: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var highlightedPreset: PeriodSelection?
    @State private var selectionTask: Task<Void, Never>?

    @ScaledMetric(relativeTo: .body) private var standardHeight: CGFloat = 44
    @ScaledMetric(relativeTo: .body) private var selectedHeight: CGFloat = 56
    @ScaledMetric(relativeTo: .body) private var titleSize: CGFloat = 14
    @ScaledMetric(relativeTo: .caption) private var detailSize: CGFloat = 12

    var body: some View {
        VStack(spacing: 0) {
            presetRow(.currentMonth, title: PeriodSelectorText.currentMonth(locale), detail: monthSubtitle)
            presetRow(.currentYear, title: PeriodSelectorText.currentYear(locale), detail: yearSubtitle)

            Rectangle()
                .fill(PeriodSelectorStyle.border)
                .frame(height: 0.5)
                .padding(.horizontal, 12)

            Button(action: onChoosePeriod) {
                Text(PeriodSelectorText.choosePeriod(locale))
                    .font(.system(size: titleSize, weight: .medium))
                    .foregroundStyle(PeriodSelectorStyle.menuText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .frame(minHeight: standardHeight)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .allowsHitTesting(selectionTask == nil)
        }
        .padding(6)
        .background(PeriodSelectorStyle.menuBackground, in: .rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(PeriodSelectorStyle.border, lineWidth: 0.5)
        }
        .shadow(color: PeriodSelectorStyle.menuShadow, radius: 10, x: 0, y: 4)
        .onDisappear { selectionTask?.cancel() }
    }

    private func presetRow(_ preset: PeriodSelection, title: String, detail: String) -> some View {
        let isSelected = (highlightedPreset ?? selection) == preset
        return Button { selectPreset(preset) } label: {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: titleSize, weight: .medium))
                        .foregroundStyle(isSelected ? PeriodSelectorStyle.capsuleForeground : PeriodSelectorStyle.menuText)
                    if isSelected {
                        Text(detail)
                            .font(.system(size: detailSize))
                            .foregroundStyle(PeriodSelectorStyle.secondaryText)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: titleSize, weight: .semibold))
                        .foregroundStyle(PeriodSelectorStyle.capsuleForeground)
                        .frame(width: 16, height: 16)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 18)
            .frame(minHeight: isSelected ? selectedHeight : standardHeight)
            .background(isSelected ? PeriodSelectorStyle.capsuleBackground : .clear, in: .rect(cornerRadius: 10))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .allowsHitTesting(selectionTask == nil)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isSelected ? "\(title), \(detail)" : title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func selectPreset(_ preset: PeriodSelection) {
        guard selectionTask == nil else { return }
        guard preset != selection else {
            onPreset(preset)
            return
        }

        if reduceMotion {
            highlightedPreset = preset
        } else {
            withAnimation(.easeInOut(duration: 0.17)) { highlightedPreset = preset }
        }

        selectionTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(reduceMotion ? 100 : 280))
            guard !Task.isCancelled else { return }
            onPreset(preset)
        }
    }

    private var monthSubtitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: referenceDate).capitalized(with: locale)
    }

    private var yearSubtitle: String {
        let year = calendar.component(.year, from: referenceDate)
        return locale.language.languageCode?.identifier == "ru" ? "\(year) год" : "\(year)"
    }
}
