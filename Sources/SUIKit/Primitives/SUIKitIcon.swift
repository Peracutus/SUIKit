import SwiftUI

/// Typed identifiers for fixed interface icons. Category icons deliberately use
/// the separate `CategoryIcon` asset catalog.
public enum SUIKitIcon: Hashable, Sendable {
    case calendar

    public var image: Image {
        switch self {
        case .calendar:
            Image(systemName: "calendar")
        }
    }
}
