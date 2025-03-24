//
//  PasswordField.swift
//  Open Money
//
//  Created by Roman on 21.06.2023.
//

import SwiftUI

public struct PasswordField: View {
    
    private let title: String
    @Binding private var text: String
    @State private var isSecured = true
    
    public init(title: String, text: Binding<String>, isSecured: Bool = true) {
        self.title = title
        self._text = text
        self.isSecured = isSecured
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                        .autocorrectionDisabled()
                }
            }
            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .foregroundColor(.semiBlack)
            }
        }
        .frame(height: 22)
    }
}
