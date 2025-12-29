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

public enum CategoryImage: String, CaseIterable {
    case Airplane
    case Babys
    case Banking
    case Barbershop
    case Beach
    case Beer
    case Bicycle
    case CarRental
    case Cars
    case Children
    case Clinic
    case Clothes
    case Cocktail
    case CoffeeToGo
    case Controller
    case CookingPot
    case CreditCard
    case Documentary
    case Exterior
    case FoodOut
    case GasStation
    case Gift
    case Grapes
    case Grocery
    case Hanger
    case Hearts
    case Hotels
    case Iphone
    case Jewelry
    case Jym
    case Kitchenwares
    case Laptop
    case Literature
    case LivingRoom
    case Mastercard
    case MoneyTransfer
    case Music
    case Puzzle
    case Restaurant
    case Sale
    case ShoppingBag
    case ShoppingCartLoaded
    case SimCard
    case SmartphoneTablet
    case Taxi
    case TheatreMask
    case Ticket
    case Tomato
    case Transport
    case Travel
    case Truck
    case Visa
    
    public var getImage: Image {
        return Image(self.rawValue, bundle: .module)
    }
    
   public static func getImage(from string: String?) -> Image? {
       return CategoryImage(rawValue: string ?? "")?.getImage
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
