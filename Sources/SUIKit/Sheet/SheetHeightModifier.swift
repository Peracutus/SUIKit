//
//  SheetHeightModifier.swift
//  SUIKit
//
//  ViewModifier для программной установки высоты sheet с анимацией
//

import SwiftUI

/// Модификатор, устанавливающий presentationDetents на основе переданной высоты.
/// Поддерживает Animatable для плавной анимации при изменении высоты.
struct SheetHeightModifier: ViewModifier, Animatable {
    var height: CGFloat

    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }

    func body(content: Content) -> some View {
        content
            .presentationDetents(height == 0 ? [.medium] : [.height(height)])
    }
}

extension View {
    /// Применяет модификатор высоты sheet
    public func sheetHeight(_ height: CGFloat) -> some View {
        modifier(SheetHeightModifier(height: height))
    }
}
