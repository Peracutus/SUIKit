//
//  TabItemView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

struct TabItemView: View {
    let image: String
    let isSelected: Bool
    let isAdditingButton: Bool
    
    var body: some View {
        VStack {
            if isAdditingButton {
                Image(systemName: image)
                    .font(.system(size: 25,
                                  weight: .regular,
                                  design: .default))
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .background(Color.skyBlue)
                    .cornerRadius(30)
            } else {
                Image(image, bundle: .module).renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .animation(.default, value: isSelected)
                    .foregroundColor(isSelected ? .skyBlue : .black)
            }
        }
    }
}
