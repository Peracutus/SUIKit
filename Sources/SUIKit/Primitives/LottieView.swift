//
//  LottieView.swift
//  Open Money
//
//  Created by Роман on 01.05.2023.
//

import SwiftUI
import Lottie
 
public struct LottieView: UIViewRepresentable {
    
    let lottieFile: String
    
    public init(lottieFile: String) {
        self.lottieFile = lottieFile
    }
 
    private let animationView = LottieAnimationView()
 
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
 
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
 
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        return view
    }
 
    public func updateUIView(_ uiView: UIViewType, context: Context) {
 
    }
}
