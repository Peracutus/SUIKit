import SwiftUI

public extension View {
    /// Styles the native Back control of the containing navigation stack.
    /// Apply to its root and each pushed destination, not to modal dismiss controls.
    func nativeBackButtonStyle(tint: Color) -> some View {
        background(NativeBackButtonStyleConfigurator(tint: tint))
    }
}

private struct NativeBackButtonStyleConfigurator: UIViewControllerRepresentable {
    let tint: Color

    func makeUIViewController(context: Context) -> NativeBackButtonStyleController {
        NativeBackButtonStyleController(tint: UIColor(tint))
    }

    func updateUIViewController(_ controller: NativeBackButtonStyleController, context: Context) {
        controller.tint = UIColor(tint)
        controller.configureIfAttached()
    }

    static func dismantleUIViewController(_ controller: NativeBackButtonStyleController, coordinator: ()) {
        controller.stop()
    }
}
