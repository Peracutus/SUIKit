import SwiftUI
import UIKit

public extension View {
    /// Configures the nearest containing `UIScrollView` for the native status-bar tap gesture.
    /// Apply this modifier to content placed inside the target `ScrollView`.
    func systemScrollsToTop(_ enabled: Bool) -> some View {
        background(SystemScrollsToTopConfigurator(enabled: enabled))
    }
}

private struct SystemScrollsToTopConfigurator: UIViewRepresentable {
    let enabled: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.scheduleConfiguration(from: uiView, enabled: enabled)
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.stop()
    }

    @MainActor
    final class Coordinator {
        private weak var configuredScrollView: UIScrollView?
        private var originalValue: Bool?
        private var configurationTask: Task<Void, Never>?

        func scheduleConfiguration(from view: UIView, enabled: Bool) {
            configurationTask?.cancel()
            configurationTask = Task { @MainActor [weak self, weak view] in
                await Task.yield()
                guard !Task.isCancelled, let self, let view else { return }
                configureNearestScrollView(from: view, enabled: enabled)
            }
        }

        func stop() {
            configurationTask?.cancel()
            configurationTask = nil
            restoreConfiguredScrollView()
        }

        private func configureNearestScrollView(from view: UIView, enabled: Bool) {
            guard let scrollView = nearestScrollView(from: view) else { return }

            if configuredScrollView !== scrollView {
                restoreConfiguredScrollView()
                configuredScrollView = scrollView
                originalValue = scrollView.scrollsToTop
            }

            scrollView.scrollsToTop = enabled
        }

        private func nearestScrollView(from view: UIView) -> UIScrollView? {
            var ancestor = view.superview
            while let current = ancestor {
                if let scrollView = current as? UIScrollView {
                    return scrollView
                }
                ancestor = current.superview
            }
            return nil
        }

        private func restoreConfiguredScrollView() {
            if let originalValue {
                configuredScrollView?.scrollsToTop = originalValue
            }
            configuredScrollView = nil
            originalValue = nil
        }
    }
}
