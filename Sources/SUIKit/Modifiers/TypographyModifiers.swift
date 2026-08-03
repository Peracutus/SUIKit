import SwiftUI

// MARK: - Amount Title Style (32px, Regular, center)
public struct AmountTitleModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .regular))
            .multilineTextAlignment(.center)
    }
}

extension View {
    public func amountTitleStyle() -> some View {
        modifier(AmountTitleModifier())
    }
}

// MARK: - Amount Label Style (14px, Regular, center, line-height 150%)
public struct AmountLabelModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular))
            .lineSpacing(14 * 0.5) // 150% line height
            .multilineTextAlignment(.center)
    }
}

extension View {
    public func amountLabelStyle() -> some View {
        modifier(AmountLabelModifier())
    }
}

// MARK: - Remaining Amount Style (12px, Regular, line-height 150%)
public struct RemainingAmountModifier: ViewModifier {
    let alignment: TextAlignment
    
    public init(alignment: TextAlignment = .leading) {
        self.alignment = alignment
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .regular))
            .lineSpacing(12 * 0.5) // 150% line height
            .multilineTextAlignment(alignment)
    }
}

extension View {
    public func remainingAmountStyle(alignment: TextAlignment = .leading) -> some View {
        modifier(RemainingAmountModifier(alignment: alignment))
    }
}

// MARK: - Participant Name Style (14px, Regular, line-height 100%)
public struct ParticipantNameModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular))
            .lineSpacing(0) // 100% line height
    }
}

extension View {
    public func participantNameStyle() -> some View {
        modifier(ParticipantNameModifier())
    }
}

// MARK: - Input Placeholder Style (14px, Regular, line-height 140%)
public struct InputPlaceholderModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular))
            .lineSpacing(14 * 0.4) // 140% line height
    }
}

extension View {
    public func inputPlaceholderStyle() -> some View {
        modifier(InputPlaceholderModifier())
    }
}

