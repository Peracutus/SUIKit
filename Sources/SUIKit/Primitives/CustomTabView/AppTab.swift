//
//  AppTab.swift
//  SUIKit
//
//  Created by Assistant on 2026-07-29.
//

import Foundation

public enum AppTab: String, CaseIterable, Hashable, Identifiable {
    case wallet
    case stats
    case calendar
    case settings

    public var id: String { rawValue }

    public var assetName: String {
        switch self {
        case .wallet:
            "Wallet"
        case .stats:
            "Stats"
        case .calendar:
            "Calendar"
        case .settings:
            "Settings"
        }
    }

    public var accessibilityLabel: String {
        switch self {
        case .wallet:
            "Wallet"
        case .stats:
            "Stats"
        case .calendar:
            "Calendar"
        case .settings:
            "Settings"
        }
    }
}
