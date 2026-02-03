//
//  SheetSize.swift
//  SUIKit
//
//  Enum для настраиваемых размеров sheet (проценты от высоты экрана)
//

import CoreGraphics

/// Размеры sheet: small ~30%, medium ~50%, large ~90% от высоты экрана
public enum SheetSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"

    /// Доля от высоты экрана
    public func height(for screenHeight: CGFloat) -> CGFloat {
        let multiplier: CGFloat
        switch self {
        case .small: multiplier = 0.30
        case .medium: multiplier = 0.50
        case .large: multiplier = 0.90
        }
        return screenHeight * multiplier
    }
}
