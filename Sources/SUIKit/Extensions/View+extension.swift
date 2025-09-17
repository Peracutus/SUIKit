//
//  View+extension.swift
//  
//
//  Created by Роман Рунов on 24.03.2025.
//

import SwiftUI
import Foundation

public struct TrayConfig {
    var maxDetent: PresentationDetent
    var cornerRadius: CGFloat
    var isInteractiveDismissDisabled: Bool
    var contentInsets: EdgeInsets
    
    public init(
        maxDetent: PresentationDetent = .fraction(0.99),
        cornerRadius: CGFloat = 16,
        isInteractiveDismissDisabled: Bool = false,
        contentInsets: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) {
        self.maxDetent = maxDetent
        self.cornerRadius = cornerRadius
        self.isInteractiveDismissDisabled = isInteractiveDismissDisabled
        self.contentInsets = contentInsets
    }
}

public extension View {
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    @ViewBuilder
    func rect(value: @escaping (CGRect) -> ()) -> some View { /// returns views position in the screen coordinate space
        self
            .overlay {
                GeometryReader(content: { geometry in
                    let rect = geometry.frame(in: .global)
                    
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: { rect in
                            value(rect)
                        })
                })
            }
    }
    
    @available(iOS 16.4, *)
    @ViewBuilder
    func systemTrayView<Content: View>(
        _ show: Binding<Bool>,
        config: TrayConfig = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .sheet(isPresented: show) {
                VStack(spacing: 0) {
                    content()
                        .padding(config.contentInsets)
                }
                .background(
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .fill(Color(.systemBackground))
                        .ignoresSafeArea(edges: .bottom)
                )
                .presentationDetents([config.maxDetent])
                .presentationCornerRadius(config.cornerRadius)
                .presentationBackground(.clear)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled(config.isInteractiveDismissDisabled)
            }
    }
}

fileprivate extension UIView {
    var dropShadowView: UIView? {
        if let superview, String(describing: type(of: superview)) == "UIDropShadowView" {
            return superview
        }
        return superview?.dropShadowView
    }
}

fileprivate struct RemoveSheetShadow: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let shadowView = view.dropShadowView {
                shadowView.layer.shadowColor = Color.clear.cgColor
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
         
    }
}

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
