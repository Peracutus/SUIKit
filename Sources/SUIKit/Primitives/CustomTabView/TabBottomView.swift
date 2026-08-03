//
//  TabBottomView.swift
//  Open Money
//
//  Created by Roman on 27.09.2023.
//

import SwiftUI

struct TabBottomView: View {
    @Binding private var selectedTab: AppTab
    private let onAddTapped: () -> Void

    public init(
        selectedTab: Binding<AppTab>,
        onAddTapped: @escaping () -> Void
    ) {
        self._selectedTab = selectedTab
        self.onAddTapped = onAddTapped
    }

    public var body: some View {
        HStack(spacing: 0) {
            TabItemView(
                tab: .wallet,
                isSelected: selectedTab == .wallet,
                action: { selectedTab = .wallet }
            )

            Spacer(minLength: 0)

            TabItemView(
                tab: .stats,
                isSelected: selectedTab == .stats,
                action: { selectedTab = .stats }
            )

            Spacer(minLength: 0)

            AddActionButton(action: onAddTapped)

            Spacer(minLength: 0)

            TabItemView(
                tab: .calendar,
                isSelected: selectedTab == .calendar,
                action: { selectedTab = .calendar }
            )

            Spacer(minLength: 0)

            TabItemView(
                tab: .settings,
                isSelected: selectedTab == .settings,
                action: { selectedTab = .settings }
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 13)
        .padding(.bottom, 21)
        .frame(maxWidth: .infinity)
        .frame(height: 83)
        .background {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color(hex: "#D9D9D9") ?? Color(uiColor: .systemGray5), lineWidth: 1)
                }
                .shadow(color: (Color(hex: "#171B2A") ?? .black).opacity(0.14), radius: 18, y: 8)
        }
    }
}

private struct AddActionButton: View {
    @GestureState private var isPressed = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            PlusIcon()
                .stroke(style: StrokeStyle(lineWidth: 2.3, lineCap: .round))
                .foregroundStyle(.white)
                .frame(width: 14, height: 14)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(Color(hex: "#6570E6") ?? .indigo)
                }
                .scaleEffect(isPressed ? 72.0 / 44.0 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in
                    state = true
                }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel("Добавить")
    }
}

private struct PlusIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let midY = rect.midY

        path.move(to: CGPoint(x: midX, y: rect.minY))
        path.addLine(to: CGPoint(x: midX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX, y: midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: midY))
        return path
    }
}
