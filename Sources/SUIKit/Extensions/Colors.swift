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
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
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
