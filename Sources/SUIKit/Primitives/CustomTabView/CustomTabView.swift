//
//  CustomTabView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

public struct CustomTabView<Content: View>: View {
    
    let tabs: [String]
    @Binding var selectedIndex: Int
    @ViewBuilder let content: (Int) -> Content
    var action: (() -> Void)?
    
    public init(
        tabs: [String],
        selectedIndex: Binding<Int>,
        @ViewBuilder content: @escaping (Int) -> Content,
        action: (() -> Void)? = nil
    ) {
        self.tabs = tabs
        self._selectedIndex = selectedIndex
        self.content = content
        self.action = action
    }

    public var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                ForEach(tabs.indices, id: \.self) { index in
                    content(index)
                        .tag(index)
                }
            }
            
            VStack {
                Spacer()
                TabBottomView(
                    tabbarItems: tabs,
                    selectedIndex: $selectedIndex,
                    action: action
                )
            }
        }
    }
}
