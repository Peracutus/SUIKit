//
//  AvatarView.swift
//  SUIKit
//
//  Универсальный аватар: инициалы (участник) или emoji (группа)
//

import SwiftUI

// MARK: - Avatar Content

/// Тип контента аватара: инициалы из имени или emoji
public enum AvatarContent {
    /// Инициалы из имени (первые буквы слов)
    case initials(name: String)
    /// Emoji (например, для групп)
    case emoji(String)
}

// MARK: - AvatarView

/// Универсальный аватар: круг с инициалами или emoji
public struct AvatarView: View {
    let content: AvatarContent
    let colorHex: String
    let size: CGFloat

    public init(
        content: AvatarContent,
        colorHex: String,
        size: CGFloat
    ) {
        self.content = content
        self.colorHex = colorHex
        self.size = size
    }

    private var displayText: String {
        switch content {
        case .initials(let name):
            return Self.generateInitials(from: name)
        case .emoji(let emoji):
            return emoji
        }
    }

    private var isEmoji: Bool {
        if case .emoji = content { return true }
        return false
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill((Color(hex: colorHex) ?? .purple).opacity(0.15))

            Text(displayText)
                .font(
                    isEmoji
                        ? .system(size: size * 0.5, weight: .regular)
                        : .system(size: size * 0.4, weight: .semibold)
                )
                .foregroundColor(Color(hex: colorHex) ?? .purple)
        }
        .frame(width: size, height: size)
    }

    /// Генерация инициалов: первые буквы первых двух слов или первая буква
    private static func generateInitials(from name: String) -> String {
        let words = name.split(separator: " ").map(String.init)

        if words.count >= 2 {
            let first = words[0].prefix(1).uppercased()
            let second = words[1].prefix(1).uppercased()
            return first + second
        } else if let first = words.first {
            return String(first.prefix(1).uppercased())
        }

        return "?"
    }
}
