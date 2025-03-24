//
//  CustomAlertButton.swift
//  Open Money
//
//  Created by Roman on 21.06.2023.
//

import SwiftUI

struct CustomAlertButton: View {

    let title: LocalizedStringKey
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
          action?()
        
        } label: {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 70)
        }
        .background(Color.skyBlue)
        .cornerRadius(10)
    }
}

struct CustomAlertButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertButton(title: "Hello world")
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.semiBlack : Color.skyBlue)
            .cornerRadius(10)
            .padding(.top, 25)
            .fontWeight(.bold)
            .scaleEffect(configuration.isPressed ? 1.03 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
