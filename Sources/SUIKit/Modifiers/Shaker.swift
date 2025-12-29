//
//  Shaker.swift
//  SUIKit
//
//  Created by Роман Рунов on 04.04.2025.
//

import SwiftUI
// Модификатор для тряски
public struct ShakeEffect: GeometryEffect {
    public var animatableData: CGFloat
    
    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = CGFloat(sin(animatableData * .pi * 4)) * 10
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
