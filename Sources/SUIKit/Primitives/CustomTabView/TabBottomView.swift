//
//  TabBottomView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

public struct TabBottomView: View {
    
    private let tabbarItems: [String]
    private var height: CGFloat = 70
    private var width: CGFloat = UIScreen.main.bounds.width - 32
    @Binding private var selectedIndex: Int
    
    private var action: (() -> Void)? = nil
    
    private var tabIndices: Range<Int> {
        return 0..<tabbarItems.count
    }
    
    public init(
        tabbarItems: [String],
        height: CGFloat = 70,
        width: CGFloat = UIScreen.main.bounds.width - 32,
        selectedIndex: Binding<Int>,
        action: (() -> Void)? = nil
    ) {
        self.tabbarItems = tabbarItems
        self.height = height
        self.width = width
        self._selectedIndex = selectedIndex
        self.action = action
    }
    
    public var body: some View {
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
