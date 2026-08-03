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

    public init(
        selectedTab: Binding<AppTab>,
        onAddTapped: @escaping () -> Void
    ) {
        self._selectedTab = selectedTab
        self.onAddTapped = onAddTapped
    }

    public var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                TabBottomView(
                    selectedTab: $selectedTab,
                    onAddTapped: onAddTapped
                )
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
