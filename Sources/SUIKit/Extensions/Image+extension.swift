//
//  Image+extension.swift
//  
//
//  Created by Роман Рунов on 24.03.2025.
//

import SwiftUI

public enum SettingsImage: String {
    case globe, currency, category, noti, key, terms, faceid, info, feedback
    
    public var getImage: Image {
        switch self {
        case .globe, .currency, .category, .noti, .key, .terms, .faceid, .info, .feedback:
            return Image(rawValue, bundle: .module)
        }
    }
}

/// The only identifier accepted by category UI. Raw values are persistence-safe,
/// semantic identifiers; the underlying asset filename is intentionally private.
public enum CategoryIcon: String, CaseIterable, Codable, Hashable, Sendable {
    case apple = "Apple"
    case baby = "Baby"
    case banknote = "Banknote"
    case book = "Book"
    case bus = "Bus"
    case car = "Car"
    case chartColumn = "ChartColumn"
    case clapperboard = "Clapperboard"
    case coffee = "Coffee"
    case creditCard = "CreditCard"
    case cross = "Cross"
    case dog = "Dog"
    case dumbbell = "Dumbbell"
    case fuel = "Fuel"
    case gamepad = "Gamepad"
    case gift = "Gift"
    case graduationCap = "GraduationCap"
    case heart = "Heart"
    case house = "House"
    case landmark = "Landmark"
    case laptop = "Laptop"
    case music = "Music"
    case percentage = "Percentage"
    case phone = "Phone"
    case piggyBank = "PiggyBank"
    case pill = "Pill"
    case plane = "Plane"
    case shoppingCart = "ShoppingCart"
    case shirt = "Shirt"
    case sparkles = "Sparkles"
    case star = "Star"
    case taxi = "Taxi"
    case utensils = "Utensils"
    case wifi = "Wifi"
    case wrench = "Wrench"
    case yoga = "Yoga"

    public static let fallback: CategoryIcon = .shoppingCart

    public var image: Image {
        Image(assetName, bundle: .module).renderingMode(.template)
    }

    /// Several SVGs were committed under the wrong filename. Keep that physical
    /// detail here so every consumer still renders the semantic icon consistently.
    private var assetName: String {
        switch self {
        case .baby: "Pill"
        case .book: "Heart"
        case .car: "Cross"
        case .cross: "House"
        case .dumbbell: "Sparkles"
        case .fuel: "Landmark"
        case .graduationCap: "Star"
        case .heart: "Wrench"
        case .house: "Car"
        case .landmark: "Baby"
        case .pill: "Fuel"
        case .plane: "GraduationCap"
        case .shirt: "Plane"
        case .sparkles: "Dumbbell"
        case .star: "Shirt"
        case .wrench: "Book"
        default: rawValue
        }
    }
}

public extension Image {
    func setupCategoryImageModifier(_ color: Color) -> some View {
        self
            .resizable()
            .frame(width: 24, height: 24)
            .background {
                Rectangle()
                    .fill(color)
                    .cornerRadius(10)
                    .frame(width: 40, height: 40)
            }
    }
    
 
}
