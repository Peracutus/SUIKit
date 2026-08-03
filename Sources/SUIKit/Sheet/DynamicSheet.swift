//
//  DynamicSheet.swift
//  SUIKit
//
//  Обёртка для sheet с динамической высотой (по контенту или по SheetSize)
//

import SwiftUI
import UIKit

/// Sheet с высотой, определяемой либо по содержимому, либо по заданному SheetSize.
public enum DynamicSheetMode {
    /// Высота подстраивается под контент (с ограничением по экрану)
    case contentBased
    /// Фиксированный размер через SheetSize (small/medium/large)
    case fixedSize(SheetSize)
}

/// Обёртка над контентом sheet с поддержкой динамической высоты
public struct DynamicSheet<Content: View>: View {
    let mode: DynamicSheetMode
    let content: () -> Content

    @State private var sheetHeight: CGFloat = 0

    private var windowSize: CGSize {
        if let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return size
        }
        return .zero
    }

    public init(mode: DynamicSheetMode = .contentBased, @ViewBuilder content: @escaping () -> Content) {
        self.mode = mode
        self.content = content
    }

    public var body: some View {
        Group {
            switch mode {
            case .contentBased:
                contentBasedSheet
            case .fixedSize(let size):
                content()
                    .modifier(SheetHeightModifier(height: size.height(for: windowSize.height)))
            }
        }
    }

    private var contentBasedSheet: some View {
        ZStack {
            content()
                .fixedSize(horizontal: false, vertical: true)
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            let maxHeight = windowSize.height - 110
            let newHeight = min(newValue.height, maxHeight)
            withAnimation(.easeInOut(duration: 0.25)) {
                sheetHeight = newHeight
            }
        }
        .modifier(SheetHeightModifier(height: sheetHeight))
    }
}

/// View modifier для применения программного размера sheet (SheetSize)
public struct SheetSizeModifier: ViewModifier {
    let size: SheetSize

    private var windowSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        return .zero
    }

    public func body(content: Content) -> some View {
        content
            .modifier(SheetHeightModifier(height: size.height(for: windowSize.height)))
    }
}

extension View {
    /// Применяет программный размер sheet через SheetSize
    public func sheetSize(_ size: SheetSize) -> some View {
        modifier(SheetSizeModifier(size: size))
    }
}
