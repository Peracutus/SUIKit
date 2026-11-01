//
//  CustomTabBar.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

public struct CustomTabBar: View {
    @Binding private var selectedTab: AppTab
    private let onAddTapped: () -> Void
    private let onTabSelected: (AppTab) -> Void

    public init(
        selectedTab: Binding<AppTab>,
        onAddTapped: @escaping () -> Void,
        onTabSelected: @escaping (AppTab) -> Void = { _ in }
    ) {
        self._selectedTab = selectedTab
        self.onAddTapped = onAddTapped
        self.onTabSelected = onTabSelected
    }

    public var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                TabBottomView(
                    selectedTab: $selectedTab,
                    onAddTapped: onAddTapped,
                    onTabSelected: onTabSelected
                )
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
