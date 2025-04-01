//
//  Colors.swift
//  
//
//  Created by Роман Рунов on 24.03.2025.
//

import SwiftUI
import UIKit

//MARK: -  hex color transformation

public extension Color {
    /// Initializes a Color from a hexadecimal string.
    /// Supports formats: #RRGGBB, RRGGBB, #RRGGBBAA, RRGGBBAA
    /// - Parameter hex: A hexadecimal color string
    init?(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        // Validate hex string
        guard hexSanitized.count == 6 || hexSanitized.count == 8,
              hexSanitized.range(of: "^[0-9A-F]+$", options: .regularExpression) != nil else {
            return nil
        }
        
        // Convert hex to UInt64
        guard let rgb = UInt64(hexSanitized, radix: 16) else { return nil }
        
        let r, g, b, a: CGFloat
        let divisor: CGFloat = 255.0
        
        if hexSanitized.count == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / divisor
            g = CGFloat((rgb & 0x00FF00) >> 8) / divisor
            b = CGFloat(rgb & 0x0000FF) / divisor
            a = 1.0
        } else {
            r = CGFloat((rgb & 0xFF000000) >> 24) / divisor
            g = CGFloat((rgb & 0x00FF0000) >> 16) / divisor
            b = CGFloat((rgb & 0x0000FF00) >> 8) / divisor
            a = CGFloat(rgb & 0x000000FF) / divisor
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    /// Converts the color to a hexadecimal string representation
    /// - Parameter includeAlpha: Whether to include the alpha component
    /// - Returns: Hexadecimal string in format #RRGGBB or #RRGGBBAA
    func toHex(includeAlpha: Bool = false) -> String? {
        guard let components = cgColor?.components else { return nil }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        let a = components.count > 3 ? components[3] : 1.0
        
        let rInt = Int(r * 255.0)
        let gInt = Int(g * 255.0)
        let bInt = Int(b * 255.0)
        let aInt = Int(a * 255.0)
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", rInt, gInt, bInt, aInt)
        } else {
            return String(format: "#%02X%02X%02X", rInt, gInt, bInt)
        }
    }


/// allow to extract hex color
    
    static let pinky = Color("PinkColor", bundle: .module)
    static let skyBlue = Color("SkyBlue", bundle: .module)
    static let lightGreen = Color("LightGreen", bundle: .module)
    static let redColor = Color("RedColor", bundle: .module)
    static let semiBlack = Color.black.opacity(0.7)
    
    static let catBlue = Color.skyBlue.opacity(0.6)
//    static let superBlue = Color.blue
    static let catRed = Color.red.opacity(0.6)
    static let catGreen = Color.green.opacity(0.6)
    static let catYellow = Color.yellow.opacity(0.6)
    static let catOrange = Color.orange.opacity(0.6)
    static let catMint = Color.mint.opacity(0.6)
    static let catCyan = Color.cyan.opacity(0.6)
    static let catIndigo = Color.indigo.opacity(0.6)
    static let catPurple = Color.purple.opacity(0.6)
    static let catBrown = Color.brown.opacity(0.6)
    static let catTeal = Color.teal.opacity(0.6)
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
