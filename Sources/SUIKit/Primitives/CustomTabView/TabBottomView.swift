//
//  TabBottomView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

struct TabBottomView: View {
    
    let tabbarItems: [String]
    var height: CGFloat = 70
    var width: CGFloat = UIScreen.main.bounds.width - 32
    var action: (() -> Void)? = nil
    @Binding var selectedIndex: Int
    
    var tabIndices: Range<Int> {
        return 0..<tabbarItems.count
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(tabIndices, id: \.self) { index in
                let item = tabbarItems[index]
                Button {
                    if index == 2 {
                        action?()
                    } else {
                        self.selectedIndex = index
                    }
                } label: {
                    let isSelected = selectedIndex == index
                    TabItemView(image: item,
                                isSelected: isSelected,
                                isAdditingButton: index == 2 ? true : false)
                    .scaleEffect(selectedIndex == index ? 1.15 : 1.0)
                }
                Spacer()
            }
        }
        .frame(height: height)
        .background {
            CustomCorners(corners: [.topLeft, .topRight], radius: 25)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(radius: 2)
        }
    }
}
