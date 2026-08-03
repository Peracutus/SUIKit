//
//  TabItemView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

struct TabItemView: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(tab.assetName, bundle: .module)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundStyle(isSelected ? activeIconColor : inactiveIconColor)
                .frame(width: 44, height: 44)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? activeBackgroundColor : .clear)
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    private var activeIconColor: Color {
        Color(hex: "#6875E0") ?? .indigo
    }

    private var inactiveIconColor: Color {
        Color(uiColor: .systemGray2)
    }

    private var activeBackgroundColor: Color {
        (Color(hex: "#635BFF") ?? .indigo).opacity(0.12)
    }
}
