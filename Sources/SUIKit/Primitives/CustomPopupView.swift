//
//  CustomPopupView.swift
//  SUIKit
//
//  Created by Roman on 15.07.2023.
//  Renamed and extended: optional dimming, tap outside to dismiss, dynamic height.
//

import SwiftUI
import UIKit

public struct CustomPopup<PopupContent>: ViewModifier where PopupContent: View {

    init(
        isPresented: Binding<Bool>,
        position: ViewPosition? = nil,
        dimBackground: Bool = true,
        view: @escaping () -> PopupContent
    ) {
        self._isPresented = isPresented
        self.view = view
        self.position = position ?? .center
        self.dimBackground = dimBackground
    }

    /// Controls whether the popup is presented
    @Binding var isPresented: Bool

    /// The content to present
    var view: () -> PopupContent
    var position: ViewPosition
    /// When true, shows a dark overlay behind the popup; tap on overlay dismisses
    var dimBackground: Bool

    // MARK: - Public Properties

    public enum ViewPosition {
        case top
        case center
        case bottom

        var isTop: Bool {
            [.top].contains(self)
        }

        var isVerticalCenter: Bool {
            [.center].contains(self)
        }

        var isBottom: Bool {
            [.bottom].contains(self)
        }

        var isHorizontalCenter: Bool {
            [.top, .center, .bottom].contains(self)
        }
    }

    // MARK: - Private Properties

    @State private var presenterContentRect: CGRect = .zero
    @State private var sheetContentRect: CGRect = .zero

    private var displayedOffset: CGFloat {
        if position.isBottom {
            return presenterContentRect.height - sheetContentRect.height
        }
        return -presenterContentRect.midY + screenHeight / 2
    }

    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return 1000
        }
        return screenHeight - presenterContentRect.midY + sheetContentRect.height / 2 + 5
    }

    private var currentOffset: CGFloat {
        isPresented ? displayedOffset : hiddenOffset
    }

    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }

    private var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }

    // MARK: - Content Builders

    public func body(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)
        }
        .overlay(sheet())
    }

    private func sheet() -> some View {
        ZStack {
            if isPresented && dimBackground {
                dimOverlay
            }
            popupContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .allowsHitTesting(isPresented)
        .animation(Animation.easeOut(duration: 0.3), value: isPresented)
    }

    /// Full-screen dark overlay; tap dismisses the popup. Hit testing blocks all actions under popup.
    private var dimOverlay: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                dismiss()
            }
    }

    /// Popup card; height is determined by content (dynamic)
    private var popupContent: some View {
        view()
            .frameGetter($sheetContentRect)
            .frame(width: screenWidth)
            .offset(x: 0, y: currentOffset)
            .animation(Animation.easeOut(duration: 0.3), value: currentOffset)
    }

    private func dismiss() {
        isPresented = false
    }
}

// MARK: - View Extension

extension View {

    public func customPopup<PopupContent: View>(
        isPresented: Binding<Bool>,
        position: CustomPopup<PopupContent>.ViewPosition? = nil,
        dimBackground: Bool = true,
        view: @escaping () -> PopupContent
    ) -> some View {
        modifier(
            CustomPopup(
                isPresented: isPresented,
                position: position,
                dimBackground: dimBackground,
                view: view
            )
        )
    }
}

// MARK: - Frame Getter (internal for popup layout)

extension View {

    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

struct FrameGetter: ViewModifier {

    @Binding var frame: CGRect

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    if rect.integral != frame.integral {
                        DispatchQueue.main.async {
                            frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            )
    }
}
