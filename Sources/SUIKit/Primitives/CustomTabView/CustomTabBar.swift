//
//  CustomTabBar.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

public struct CustomTabBar: View {

    let tabs: [String]
    @Binding var selectedIndex: Int
    let action: (() -> Void)?

    private let height: CGFloat = 100

    public init(
        tabs: [String],
        selectedIndex: Binding<Int>,
        action: (() -> Void)? = nil
    ) {
        self.tabs = tabs
        self._selectedIndex = selectedIndex
        self.action = action
    }

    public var body: some View {
        VStack {
            Spacer()
            TabBottomView(
                tabbarItems: tabs,
                selectedIndex: $selectedIndex,
                action: action
            )
            .frame(height: height)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
