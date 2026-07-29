import SwiftUI

public struct SplitParticipantModel: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let amount: String
    public let isPaid: Bool
    
    public init(
        id: UUID,
        name: String,
        amount: String,
        isPaid: Bool
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.isPaid = isPaid
    }
}

public struct TransactionRowModel: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let amount: String
    public let iconName: String
    public let iconColor: Color
    public let transactionType: TransactionRowType
    public let isRegular: Bool
    public let isSplit: Bool
    public let splitStatus: SplitStatus?
    public let splitParticipants: [SplitParticipantModel]?
    
    // MARK: - Equatable
    public static func == (lhs: TransactionRowModel, rhs: TransactionRowModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.amount == rhs.amount &&
        lhs.iconName == rhs.iconName &&
        lhs.isRegular == rhs.isRegular &&
        lhs.isSplit == rhs.isSplit &&
        lhs.splitStatus == rhs.splitStatus &&
        lhs.splitParticipants == rhs.splitParticipants
    }
    
    public init(
        id: UUID,
        title: String,
        subtitle: String? = nil,
        amount: String,
        iconName: String,
        iconColor: Color,
        transactionType: TransactionRowType,
        isRegular: Bool = false,
        isSplit: Bool = false,
        splitStatus: SplitStatus? = nil,
        splitParticipants: [SplitParticipantModel]? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.iconName = iconName
        self.iconColor = iconColor
        self.transactionType = transactionType
        self.isRegular = isRegular
        self.isSplit = isSplit
        self.splitStatus = splitStatus
        self.splitParticipants = splitParticipants
    }
}

public enum TransactionRowType: Equatable {
    case income
    case expense
}

public enum SplitStatus: Equatable {
    case noParticipants
    case pending
    case completed
}
