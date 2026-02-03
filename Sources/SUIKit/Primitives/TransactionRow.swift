import SwiftUI

public struct TransactionRow: View, Equatable {
    public let model: TransactionRowModel
    public let onTransactionTap: ((UUID) -> Void)?
    public let onDelete: ((UUID) -> Void)?
    
    public init(
        model: TransactionRowModel,
        onTransactionTap: ((UUID) -> Void)? = nil,
        onDelete: ((UUID) -> Void)? = nil
    ) {
        self.model = model
        self.onTransactionTap = onTransactionTap
        self.onDelete = onDelete
    }
    
    // MARK: - Equatable
    public static func == (lhs: TransactionRow, rhs: TransactionRow) -> Bool {
        lhs.model == rhs.model
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(model.iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: model.iconName)
                        .foregroundColor(model.iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .fontWeight(.medium)
                    if let subtitle = model.subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        Text(model.transactionType == .income ? "+" : "-")
                            .fontWeight(.semibold)
                            .foregroundColor(model.transactionType == .income ? Color.success : .primary)
                        
                        Text(model.amount)
                            .fontWeight(.semibold)
                            .foregroundColor(model.transactionType == .income ? Color.success : .primary)
                    }
                    if model.isSplit || model.isRegular {
                        HStack(spacing: 10) {
                            if model.isSplit  {
                                Image(systemName: "scissors")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#7D7DDE") ?? .purple)
                                    .frame(minWidth: 44, minHeight: 44) // ✅ Минимальный Hit Target
                            }
                            if model.isRegular {
                                Image(systemName: "repeat")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#7D7DDE") ?? .purple)
                                    .frame(minWidth: 44, minHeight: 44) // ✅ Минимальный Hit Target
                            }
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTransactionTap?(model.id)
            }
        }
    }
}

