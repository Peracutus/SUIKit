//
//  PasswordField.swift
//  Open Money
//
//  Created by Roman on 21.06.2023.
//

import SwiftUI

struct PasswordField: View {
    
    let title: String
    @Binding var text: String
    @State private var isSecured = true
    
    var body: some View {
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
