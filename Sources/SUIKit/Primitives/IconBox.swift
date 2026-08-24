//
//  IconBox.swift
//  SUIKit
//
//  Created by Auto on 2025.
//  Переиспользуемый компонент для отображения иконки в фрейме
//

import SwiftUI

/// Переиспользуемый компонент для отображения иконки в фрейме
/// Используется для категорий и других элементов с иконками
public struct IconBox: View {
    public let icon: CategoryIcon
    /// Цвет иконки и фона
    public let color: Color
    /// Размер фрейма (по умолчанию 48x48)
    public let frameSize: CGFloat
    /// Размер иконки (по умолчанию вычисляется как frameSize * 0.5)
    public let iconSize: CGFloat
    /// Радиус скругления углов (по умолчанию 9)
    public let cornerRadius: CGFloat
    
    public init(
        icon: CategoryIcon,
        color: Color,
        frameSize: CGFloat = 48,
        iconSize: CGFloat? = nil,
        cornerRadius: CGFloat = 9
    ) {
        self.icon = icon
        self.color = color
        self.frameSize = frameSize
        self.iconSize = iconSize ?? frameSize * 0.5
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color.opacity(0.15))
                .frame(width: frameSize, height: frameSize)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .animation(.easeInOut(duration: 0.3), value: color)
            
            icon.image
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(color)
                .id(icon)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                .animation(.easeInOut(duration: 0.3), value: icon)
                .animation(.easeInOut(duration: 0.3), value: color)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            IconBox(icon: .shoppingCart, color: .blue)
            IconBox(icon: .house, color: .green)
            IconBox(icon: .car, color: .orange)
        }
        
        HStack(spacing: 20) {
            IconBox(icon: .shoppingCart, color: .blue, frameSize: 80)
            IconBox(icon: .house, color: .green, frameSize: 80)
            IconBox(icon: .car, color: .orange, frameSize: 80)
        }
    }
    .padding()
}
