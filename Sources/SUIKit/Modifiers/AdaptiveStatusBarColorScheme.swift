import SwiftUI

public extension View {
    /// Applies a status-bar color scheme without changing the color scheme of the content.
    func adaptiveStatusBarColorScheme(_ colorScheme: ColorScheme?) -> some View {
        toolbarColorScheme(colorScheme, for: .navigationBar)
    }
}
