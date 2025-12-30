//
//  SubmitButton.swift
//  SUIKit
//
//  Created by Роман Рунов on 02.04.2025.
//

import SwiftUI

/// Переиспользуемая кнопка подтверждения/готово
public struct SubmitButton: View {
    private let title: String
    private let backgroundColor: Color
    private let action: () -> Void
    
    public init(
        title: String = "Готово",
        backgroundColor: Color = Color(hex: "#B36198") ?? .purple,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(backgroundColor)
                .cornerRadius(60)
        }
        .buttonStyle(.plain)
    }
}

