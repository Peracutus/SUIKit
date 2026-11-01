import Foundation
import SwiftUI
import XCTest
@testable import SUIKit

final class CategoryImageModelTests: XCTestCase {
    func testDecodesKnownAndLegacyUnknownIconsWithoutLosingCategory() throws {
        let id = UUID()
        for (rawIcon, expectedIcon) in [("Apple", CategoryIcon.apple), ("", .fallback), ("LegacyCustom", .fallback)] {
            let json = """
            {"id":"\(id.uuidString)","icon":"\(rawIcon)","iconColor":"#AABBCC","categoryTitle":"Groceries"}
            """
            let model = try JSONDecoder().decode(CategoryImageModel.self, from: Data(json.utf8))
            XCTAssertEqual(model.id, id)
            XCTAssertEqual(model.icon, expectedIcon)
            XCTAssertEqual(model.iconColor, "#AABBCC")
            XCTAssertEqual(model.categoryTitle, "Groceries")
            XCTAssertEqual(try JSONDecoder().decode(CategoryImageModel.self, from: JSONEncoder().encode(model)), model)
        }
    }

    func testLegacyStringInitializersMapUnknownIconsToFallback() {
        XCTAssertEqual(CategoryImageModel(icon: "Apple").icon, .apple)
        XCTAssertEqual(CategoryImageModel(icon: "Unknown").icon, .fallback)
        let row = TransactionRowModel(
            id: UUID(),
            title: "Expense",
            amount: "100",
            iconName: "Unknown",
            iconColor: .blue,
            transactionType: .expense
        )
        XCTAssertEqual(row.iconName, .fallback)
    }
}
