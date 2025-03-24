//
//  CustomTabView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

//struct CustomTabView<Content: View>: View {
//    let tabs: [String]
//    @EnvironmentObject var globalStorage: SettingsStorageService
//    @Binding var selectedIndex: Int
//    @ViewBuilder let content: (Int) -> Content
//    var action: (() -> Void)? = nil
//
//    var body: some View {
//        ZStack {
//            TabView(selection: $selectedIndex) {
//                ForEach(tabs.indices, id: \.self) { index in
//                    content(index)
//                        .tag(index)
//                }
//            }
//            if !globalStorage.tabBarIsHidden {
//                VStack {
//                    Spacer()
//                    TabBottomView(tabbarItems: tabs, action: action, selectedIndex: $selectedIndex)
//                }
//            }
//        }
//    }
//}
