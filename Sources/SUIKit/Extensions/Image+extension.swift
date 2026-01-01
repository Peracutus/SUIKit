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

public enum CategoryIcon {
    
    // MARK: - Income (Доходы)
    
    /// Иконки для категории доходов
    public enum Income: String, CaseIterable {
        case arrowDownCircleFill = "arrow.down.circle.fill"
        case plusCircleFill = "plus.circle.fill"
        case banknoteFill = "banknote.fill"
        case creditcardFill = "creditcard.fill"
        case buildingColumnsFill = "building.columns.fill"
        case dollarsignCircleFill = "dollarsign.circle.fill"
        case eurosignCircleFill = "eurosign.circle.fill"
        case yensignCircleFill = "yensign.circle.fill"
        case bitcoinsignCircleFill = "bitcoinsign.circle.fill"
        case handWaveFill = "hand.wave.fill"
        case briefcaseFill = "briefcase.fill"
        case giftFill = "gift.fill"
        case trophyFill = "trophy.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Expenses (Расходы)
    
    /// Иконки для категории расходов
    public enum Expenses: String, CaseIterable {
        case arrowUpCircleFill = "arrow.up.circle.fill"
        case minusCircleFill = "minus.circle.fill"
        case cartFill = "cart.fill"
        case bagFill = "bag.fill"
        case takeoutbagAndCupAndStrawFill = "takeoutbag.and.cup.and.straw.fill"
        case forkKnife = "fork.knife"
        case carFill = "car.fill"
        case fuelpumpFill = "fuelpump.fill"
        case houseFill = "house.fill"
        case boltFill = "bolt.fill"
        case dropFill = "drop.fill"
        case flameFill = "flame.fill"
        case wifi = "wifi"
        case phoneFill = "phone.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Housing (Жилье)
    
    /// Иконки для категории жилья
    public enum Housing: String, CaseIterable {
        case houseFill = "house.fill"
        case keyFill = "key.fill"
        case sofaFill = "sofa.fill"
        case lightbulbFill = "lightbulb.fill"
        case wrenchFill = "wrench.fill"
        case paintbrushFill = "paintbrush.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Transport (Транспорт)
    
    /// Иконки для категории транспорта
    public enum Transport: String, CaseIterable {
        case carFill = "car.fill"
        case busFill = "bus.fill"
        case tramFill = "tram.fill"
        case airplane = "airplane"
        case bicycle = "bicycle"
        case scooter = "scooter"
        case parkingsign = "parkingsign"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Food (Еда)
    
    /// Иконки для категории еды
    public enum Food: String, CaseIterable {
        case cartFill = "cart.fill"
        case bagFill = "bag.fill"
        case takeoutbagAndCupAndStrawFill = "takeoutbag.and.cup.and.straw.fill"
        case forkKnife = "fork.knife"
        case cupAndSaucerFill = "cup.and.saucer.fill"
        case wineglassFill = "wineglass.fill"
        case birthdayCakeFill = "birthday.cake.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Shopping (Покупки)
    
    /// Иконки для категории покупок
    public enum Shopping: String, CaseIterable {
        case bagFill = "bag.fill"
        case tshirtFill = "tshirt.fill"
        case shoeprintsFill = "shoeprints.fill"
        case giftFill = "gift.fill"
        case cartFill = "cart.fill"
        case creditcardFill = "creditcard.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Health (Здоровье)
    
    /// Иконки для категории здоровья
    public enum Health: String, CaseIterable {
        case heartFill = "heart.fill"
        case crossCaseFill = "cross.case.fill"
        case pillsFill = "pills.fill"
        case stethoscope = "stethoscope"
        case figureRun = "figure.run"
        case dumbbellFill = "dumbbell.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Entertainment (Развлечения)
    
    /// Иконки для категории развлечений
    public enum Entertainment: String, CaseIterable {
        case filmFill = "film.fill"
        case tvFill = "tv.fill"
        case gamecontrollerFill = "gamecontroller.fill"
        case ticketFill = "ticket.fill"
        case musicNote = "music.note"
        case bookFill = "book.fill"
        case newspaperFill = "newspaper.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Education (Образование)
    
    /// Иконки для категории образования
    public enum Education: String, CaseIterable {
        case bookFill = "book.fill"
        case graduationcapFill = "graduationcap.fill"
        case studentdesk = "studentdesk"
        case pencil = "pencil"
        case backpackFill = "backpack.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Business (Бизнес)
    
    /// Иконки для категории бизнеса
    public enum Business: String, CaseIterable {
        case briefcaseFill = "briefcase.fill"
        case docTextFill = "doc.text.fill"
        case printerFill = "printer.fill"
        case network = "network"
        case buildingFill = "building.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Travel (Путешествия)
    
    /// Иконки для категории путешествий
    public enum Travel: String, CaseIterable {
        case airplane = "airplane"
        case bedDoubleFill = "bed.double.fill"
        case suitcaseFill = "suitcase.fill"
        case mapFill = "map.fill"
        case beachUmbrellaFill = "beach.umbrella.fill"
        case mountain2Fill = "mountain.2.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Gifts (Подарки)
    
    /// Иконки для категории подарков
    public enum Gifts: String, CaseIterable {
        case giftFill = "gift.fill"
        case giftcardFill = "giftcard.fill"
        case partyPopperFill = "party.popper.fill"
        case balloonFill = "balloon.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Bills (Платежи и счета)
    
    /// Иконки для категории платежей и счетов
    public enum Bills: String, CaseIterable {
        case docTextFill = "doc.text.fill"
        case envelopeFill = "envelope.fill"
        case creditcardFill = "creditcard.fill"
        case banknoteFill = "banknote.fill"
        case clockFill = "clock.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Transfers (Переводы)
    
    /// Иконки для категории переводов
    public enum Transfers: String, CaseIterable {
        case arrowLeftArrowRight = "arrow.left.arrow.right"
        case person2Fill = "person.2.fill"
        case qrcode = "qrcode"
        case banknoteFill = "banknote.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Analytics (Аналитика)
    
    /// Иконки для категории аналитики
    public enum Analytics: String, CaseIterable {
        case chartPieFill = "chart.pie.fill"
        case chartBarFill = "chart.bar.fill"
        case chartLineUptrendXyaxis = "chart.line.uptrend.xyaxis"
        case waveformPathEcg = "waveform.path.ecg"
        case listBullet = "list.bullet"
        case magnifyingglass = "magnifyingglass"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Settings (Настройки)
    
    /// Иконки для категории настроек
    public enum Settings: String, CaseIterable {
        case gearshapeFill = "gearshape.fill"
        case personFill = "person.fill"
        case bellFill = "bell.fill"
        case lockFill = "lock.fill"
        case icloudFill = "icloud.fill"
        case squareAndArrowDown = "square.and.arrow.down"
        case docTextFill = "doc.text.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Accounts (Счета и карты)
    
    /// Иконки для категории счетов и карт
    public enum Accounts: String, CaseIterable {
        case creditcardFill = "creditcard.fill"
        case banknoteFill = "banknote.fill"
        case buildingColumnsFill = "building.columns.fill"
        case walletPassFill = "wallet.pass.fill"
        case safeFill = "safe.fill"
        case chartLineUptrendXyaxis = "chart.line.uptrend.xyaxis"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Planning (Планирование)
    
    /// Иконки для категории планирования
    public enum Planning: String, CaseIterable {
        case calendar = "calendar"
        case clockFill = "clock.fill"
        case target = "target"
        case checklist = "checklist"
        case flagFill = "flag.fill"
        case starFill = "star.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Security (Безопасность)
    
    /// Иконки для категории безопасности
    public enum Security: String, CaseIterable {
        case lockFill = "lock.fill"
        case faceid = "faceid"
        case shieldFill = "shield.fill"
        case keyFill = "key.fill"
        case exclamationmarkTriangle = "exclamationmark.triangle"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Recurring (Регулярные)
    
    /// Иконки для категории регулярных платежей
    public enum Recurring: String, CaseIterable {
        case repeating = "repeat"
        case arrowClockwise = "arrow.clockwise"
        case calendarBadgeClock = "calendar.badge.clock"
        case bellFill = "bell.fill"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
        }
    }
    
    // MARK: - Management (Управление категориями)
    
    /// Иконки для категории управления
    public enum Management: String, CaseIterable {
        case folderFill = "folder.fill"
        case tagFill = "tag.fill"
        case bookmarkFill = "bookmark.fill"
        case squareGrid2x2 = "square.grid.2x2"
        
        public var getImage: Image {
            return Image(systemName: self.rawValue)
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
