//
//  ActionRow.swift
//  SUIKit
//
//  Reusable action row component
//

import SwiftUI

/// Модель элемента действия (совместима с локальной версией)
public struct ActionItem: Identifiable {
    public let id: UUID
    public let customView: AnyView?
    public let systemImage: String?
    public let accessibilityLabel: String
    public let isPrimary: Bool
    public let action: () -> Void
    
    public init(
        id: UUID = UUID(),
        customView: AnyView? = nil,
        systemImage: String? = nil,
        accessibilityLabel: String,
        isPrimary: Bool = false,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.customView = customView
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.isPrimary = isPrimary
        self.action = action
    }
    
    // Инициализаторы для совместимости с локальной версией
    public init(
        systemImage: String,
        accessibilityLabel: String,
        isPrimary: Bool = false,
        action: @escaping () -> Void
    ) {
        self.id = UUID()
        self.systemImage = systemImage
        self.customView = nil
        self.accessibilityLabel = accessibilityLabel
        self.isPrimary = isPrimary
        self.action = action
    }
    
    public init(
        customView: AnyView,
        accessibilityLabel: String = "",
        isPrimary: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.id = UUID()
        self.systemImage = nil
        self.customView = customView
        self.accessibilityLabel = accessibilityLabel
        self.isPrimary = isPrimary
        self.action = action
    }
}

/// Строка с действиями (кнопками)
public struct ActionRow: View {
    let items: [ActionItem]
    let spacing: CGFloat
    
    public init(
        items: [ActionItem],
        spacing: CGFloat = 12
    ) {
        self.items = items
        self.spacing = spacing
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(items) { item in
                if let custom = item.customView {
                    Button(action: item.action) {
                        custom
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(item.accessibilityLabel))
                } else if let system = item.systemImage {
                    Button(action: item.action) {
                        Image(systemName: system)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(10)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(item.isPrimary ? Color.primary.opacity(0.12) : .clear, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(item.accessibilityLabel))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

