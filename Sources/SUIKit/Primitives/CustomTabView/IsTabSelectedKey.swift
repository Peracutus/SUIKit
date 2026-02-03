//
//  IsTabSelectedKey.swift
//  SUIKit
//
//  Created for tab-based status bar control
//

import SwiftUI

struct IsTabSelectedKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

public extension EnvironmentValues {
    /// true, если текущая вкладка активна (для условного statusBarHidden при переключении табов)
    var isTabSelected: Bool {
        get { self[IsTabSelectedKey.self] }
        set { self[IsTabSelectedKey.self] = newValue }
    }
}
