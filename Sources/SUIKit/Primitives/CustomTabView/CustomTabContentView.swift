//
//  CustomTabContentView.swift
//  SUIKit
//
//  Created by Роман Рунов on 28.12.2025.
//

import SwiftUI

public struct CustomTabContentView<Content: View>: View {

    let tabs: [String]
    @Binding var selectedIndex: Int
    @ViewBuilder let content: (Int) -> Content

    public init(
        tabs: [String],
        selectedIndex: Binding<Int>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.tabs = tabs
        self._selectedIndex = selectedIndex
        self.content = content
    }

    public var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(tabs.indices, id: \.self) { index in
                content(index)
                    .tag(index)
            }
        }
    }
}
