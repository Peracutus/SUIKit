import SwiftUI

public struct TransactionRowStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(AppSpacing.m)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(AppRadius.medium)
    }
}

public extension View {
    func transactionRowStyle() -> some View {
        modifier(TransactionRowStyle())
    }
}

