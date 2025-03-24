//
//  CustomAlert.swift
//  Open Money
//
//  Created by Roman on 21.06.2023.
//

import SwiftUI

public struct CustomAlert: View {

    // MARK: - Properties
    // MARK: Public
    let title: String
    let message: String
    let dismissButton: CustomAlertButton?
    
    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat             = 0.001
    
    public init(
        title: String,
        message: String,
        dismissButton: CustomAlertButton?
    ) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
    }

    @Environment(\.dismiss) private var dismiss

    // MARK: - View
    public var body: some View {
        ZStack {
            dimView
    
            alertView
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .task {
            animate(isShown: true)
        }
    }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 20) {
            titleView
            messageView
            buttonView
        }
        .padding(24)
        .frame(width: UIScreen.main.bounds.width - 50)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
//                .lineSpacing(24 - UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var messageView: some View {
        if !message.isEmpty {
            Text(message)
                .font(.system(size: title.isEmpty ? 18 : 16))
                .foregroundColor(title.isEmpty ? .black : .gray)
                .lineSpacing(24 - UIFont.systemFont(ofSize: title.isEmpty ? 18 : 16).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var buttonView: some View {
        HStack(spacing: 12) {
            if dismissButton != nil {
                dismissButtonView
            }
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private var dismissButtonView: some View {
        if let button = dismissButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
                    dismiss()
                }
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    button.action?()
                }
            }
        }
    }

    private var dimView: some View {
        Color.gray
            .opacity(opacity)
            .opacity(backgroundOpacity)
    }

    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
    
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0)) {
                backgroundOpacity = 0.4
                scale             = 1
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
    
        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity           = 0
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}

#if DEBUG
struct CustomAlert_Previews: PreviewProvider {

    static var previews: some View {
        let dismissButton   = CustomAlertButton(title: "OK")

        let title = "This is your life. Do what you want and do it often."
        let message = """
                    If you don't like something, change it.
                    If you don't like your job, quit.
                    If you don't have enough time, stop watching TV.
                    """

        return VStack {
            CustomAlert(title: title, message: message, dismissButton: dismissButton)
        }
        .previewDevice("iPhone 13 Pro Max")
        .preferredColorScheme(.light)
    }
}
#endif
