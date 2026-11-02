//
//  CategoryImageModel.swift
//  SUIKit
//
//  Created by Роман Рунов on 02.04.2025.
//

import SwiftUI

public struct CategoryImageModel: Codable, Hashable, Identifiable {
    public var id: UUID
    public var icon: CategoryIcon
    public var iconColor: String
    public var categoryTitle: String
    
    public init(
        id: UUID = UUID(),
        icon: CategoryIcon = .fallback,
        iconColor: String = "",
        categoryTitle: String = ""
    ) {
        self.id = id
        self.icon = icon
        self.iconColor = iconColor
        self.categoryTitle = categoryTitle
    }

    @available(*, deprecated, message: "Use a CategoryIcon rather than an asset-name String")
    public init(
        id: UUID = UUID(),
        icon: String,
        iconColor: String = "",
        categoryTitle: String = ""
    ) {
        self.init(
            id: id,
            icon: CategoryIcon(rawValue: icon) ?? .fallback,
            iconColor: iconColor,
            categoryTitle: categoryTitle
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id, icon, iconColor, categoryTitle
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let rawIcon = try container.decode(String.self, forKey: .icon)
        // Earlier versions persisted arbitrary asset names, including an empty
        // default. Preserve the rest of the model when an icon is no longer known.
        icon = CategoryIcon(rawValue: rawIcon) ?? .fallback
        iconColor = try container.decode(String.self, forKey: .iconColor)
        categoryTitle = try container.decode(String.self, forKey: .categoryTitle)
    }
}
