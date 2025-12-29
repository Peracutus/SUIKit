//
//  FilterButton.swift
//  SUIKit
//
//  Reusable filter button component
//

import SwiftUI

/// Универсальная кнопка фильтра с поддержкой выбранного состояния
public struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let selectedColor: Color
    let unselectedColor: Color
    
    public init(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void,
        selectedColor: Color = .blue,
        unselectedColor: Color = .gray.opacity(0.2)
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? selectedColor : unselectedColor)
                )
        }
    }
}

/// Группа кнопок фильтра для Optional типов
public struct FilterButtonGroup<Selection: Hashable>: View {
    let options: [(title: String, value: Selection?)]
    @Binding var selection: Selection?
    let selectedColor: Color
    let unselectedColor: Color
    
    public init(
        options: [(title: String, value: Selection?)],
        selection: Binding<Selection?>,
        selectedColor: Color = .blue,
        unselectedColor: Color = .gray.opacity(0.2)
    ) {
        self.options = options
        self._selection = selection
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                FilterButton(
                    title: option.title,
                    isSelected: {
                        if let value = option.value {
                            return selection == value
                        } else {
                            return selection == nil
                        }
                    }(),
                    action: { selection = option.value },
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor
                )
            }
        }
    }
}

