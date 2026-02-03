import SwiftUI

public enum AppTypography {
    public static func headline(size: CGFloat = 18, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight)
    }
    
    public static func body(size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
    
    public static func caption(size: CGFloat = 12, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
    
    public static func title(size: CGFloat = 34, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight)
    }
}

