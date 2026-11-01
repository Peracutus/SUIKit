import SwiftUI

public extension View {
    /// Styles the native Back control of the containing navigation stack.
    /// Apply to its root and each pushed destination, not to modal dismiss controls.
    func nativeBackButtonStyle(tint: Color) -> some View {
        self.tint(tint)
            .background(NativeBackButtonStyleConfigurator())
    }
}

private struct NativeBackButtonStyleConfigurator: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> NativeBackButtonStyleController {
        NativeBackButtonStyleController()
    }

    func updateUIViewController(_ controller: NativeBackButtonStyleController, context: Context) {
        controller.configureIfAttached()
    }

    static func dismantleUIViewController(_ controller: NativeBackButtonStyleController, coordinator: ()) {
        controller.stop()
    }
}
