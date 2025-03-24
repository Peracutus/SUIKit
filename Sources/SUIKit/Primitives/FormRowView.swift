//
//  FormRowView.swift
//  Open Money
//
//  Created by Roman on 29.04.2023.
//

import SwiftUI

struct FormRowView: View {
    
    //MARK: - Properties
    @Binding var isActive: Bool
    
    var icon: String
    var text: String
    var isSwitcher: Bool = false
    let completion: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white)
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.skyBlue)
                
            }
            .frame(width: 36, height: 36, alignment: .center)
            .shadow(radius: 0.05)
            
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
        
        FormRowView(isActive: $value, icon: "globe", text: "Website", completion: {
            print("123")
        })
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
        
        FormRowView(isActive: $value, icon: "globe", text: "Website", isSwitcher: true, completion: {
            print("123")
        })
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
