//
//  DateTimePill.swift
//  SUIKit
//
//  Reusable date/time pill component
//

import SwiftUI

/// Компонент для отображения даты и времени в виде пилюли
public struct DateTimePill: View {
    @Binding var date: Date
    let showTime: Bool
    let style: DateTimePillStyle
    
    public enum DateTimePillStyle {
        case compact
        case detailed
    }
    
    public init(
        date: Binding<Date>,
        showTime: Bool = true,
        style: DateTimePillStyle = .compact
    ) {
        self._date = date
        self.showTime = showTime
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 14, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(date, style: .date)
                    .font(.system(size: 13, weight: .semibold))
                
                if showTime {
                    Text(date, style: .time)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
    }
}

