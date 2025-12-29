//
//  KeypadButton.swift
//  SUIKit
//
//  Created by Роман Рунов on 02.04.2025.
//

import SwiftUI

public struct KeypadButton: View {
    private let title: String
    private var isSystemImage: Bool
    private let action: () -> Void
    
    public init(
        title: String,
        isSystemImage: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSystemImage = isSystemImage
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Group {
                if isSystemImage {
                    Image(systemName: title)
                } else {
                    Text(title)
                }
            }
            .font(.title2.bold())
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .contentShape(Rectangle())
        }
    }
}
