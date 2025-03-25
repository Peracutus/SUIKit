//
//  String+extension.swift
//  
//
//  Created by Роман Рунов on 24.03.2025.
//

public extension String {
    
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
    }
    
    /// CategoryColors
    public enum CategoryColors: String {
        case CatBlue = "#0432FF"
        case CatRed = "#FF2600"
        case CatGreen = "#00F900"
        case CatYellow = "#FEFB00"
        case CatOrange = "#FF9200"
        case CatCyan = "#00FCFF"
        case CatPurple = "#932092"
        case CatBrown = "#AA7941"
        //      case SuperBlue
        //      case CatMint
        //      case CatIndigo
        //      case CatTeal
    }
}
