//
//  CustomCorners.swift
//  Open Money
//
//  Created by Роман on 01.05.2023.
//

import SwiftUI

public struct CustomCorners: Shape {
    
    private var corners: UIRectCorner
    private var radius: CGFloat
    
    public init(corners: UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }
    
   public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

