//
//  Image+extension.swift
//  
//
//  Created by Роман Рунов on 24.03.2025.
//

import SwiftUI

public enum SettingsImage: String {
    case globe, currency, cats, noti, key, terms, faceid, info, feedback
    
    public var getImage: Image {
        switch self {
        case .globe, .currency, .cats, .noti, .key, .terms, .faceid, .info, .feedback:
            return Image(rawValue, bundle: .module)
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
