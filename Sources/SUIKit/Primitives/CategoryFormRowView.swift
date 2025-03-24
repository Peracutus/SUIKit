//
//  CategoryFormRowView.swift
//  Open Money
//
//  Created by Roman on 11.07.2023.
//

import SwiftUI

public struct CategoryFormRowView: View {
    
    //MARK: - Properties
    private let title: String
    private let count: String
    private let transaction: String
    private let percent: String
    private let image: String
    private let color: Color
    
    public init(
        title: String,
        count: String,
        transaction: String,
        percent: String,
        image: String,
        color: Color
    ) {
        self.title = title
        self.count = count
        self.transaction = transaction
        self.percent = percent
        self.image = image
        self.color = color
    }
    
    //MARK: - Body
    public var body: some View {
        ZStack {
            
            HStack(alignment: .center, spacing: 5) {
                
                Image(image)
                    .setupCategoryImageModifier(color)
                
                VStack {
                    
                    HStack {
                        Text(title)
                        Spacer()
                        Text(count)
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    
                    HStack {
                        Text(transaction)
                        Spacer()
                        Text(percent)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                }
                .padding(.all)
            }
            .padding(.leading, 20)
            .background {
                Rectangle()
                    .fill(.white)
                    .cornerRadius(15)
                    .shadow(radius: 1)
            }
        }
    }
}

struct CategoryFormRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        CategoryFormRowView(title: "Eating out", count: "₽ 2 000 000", transaction: "25 transactions", percent: "40%", image: "FoodOut", color: .skyBlue.opacity(0.6))
    }
    
}
