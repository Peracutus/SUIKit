//
//  FormRowView.swift
//  Open Money
//
//  Created by Roman on 29.04.2023.
//

import SwiftUI

public struct FormRowView: View {
    
    //MARK: - Properties
    private let icon: SettingsImage
    private let text: String
    private var isSwitcher: Bool = false
    @Binding private var isActive: Bool
    let completion: () -> Void
    
    public init(
        icon: SettingsImage,
        text: String,
        isActive: Binding<Bool>,
        isSwitcher: Bool = false,
        completion: @escaping () -> Void
    ) {
        self.icon = icon
        self.text = text
        self._isActive = isActive
        self.isSwitcher = isSwitcher
        self.completion = completion
    }
    
    public var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white)
                icon
                    .getImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.skyBlue)
                
            }
            .frame(width: 36, height: 36, alignment: .center)
            .shadow(radius: 0.15)
            
            if isSwitcher {
                Toggle(isOn: $isActive) {
                    Text(text)
                }
                .toggleStyle(SwitchToggleStyle(tint: .skyBlue))
            } else {
                Text(text)
                Spacer()
                Button {
                    completion()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .accentColor(Color(.systemGray2))
            }
        }
        .frame(height: 40)
    }
}

struct FormRowLinkView_Previews: PreviewProvider {
    
    @State static var value = false
    
    static var previews: some View {
        
        FormRowView(icon: .globe, text: "Website", isActive: $value, completion: {
            print("123")
        })
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
        
        FormRowView(icon: .globe, text: "Website", isActive: $value, completion: {
            print("123")
        })
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
