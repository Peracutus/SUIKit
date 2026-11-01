import SwiftUI

/// iOS 26 alternative to CustomTabBar with the same selection and action API.
@available(iOS 26.0, *)
public struct GlassTabBar: View {
    @Binding private var selectedTab: AppTab
    private let onAddTapped: () -> Void
    private let onTabSelected: (AppTab) -> Void
    @Namespace private var selectionNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        selectedTab: Binding<AppTab>,
        onAddTapped: @escaping () -> Void,
        onTabSelected: @escaping (AppTab) -> Void = { _ in }
    ) {
        _selectedTab = selectedTab
        self.onAddTapped = onAddTapped
        self.onTabSelected = onTabSelected
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                GlassEffectContainer {
                    HStack(spacing: 0) {
                        tab(.wallet)
                        tab(.stats)
                        addButton
                        tab(.calendar)
                        tab(.settings)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .glassEffect(.regular, in: .capsule)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, max(10, geometry.safeAreaInsets.bottom))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private func tab(_ tab: AppTab) -> some View {
        Button {
            if reduceMotion { selectedTab = tab }
            else { withAnimation(.smooth(duration: 0.2)) { selectedTab = tab } }
            onTabSelected(tab)
        } label: {
            Image(tab.assetName, bundle: .module)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(selectedTab == tab ? SemanticColors.selectedText : SemanticColors.secondaryText)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background {
                    if selectedTab == tab {
                        Capsule()
                            .fill(SemanticColors.selectedFill.opacity(0.7))
                            .matchedGeometryEffect(id: "selected-tab", in: selectionNamespace)
                    }
                }
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.accessibilityLabel)
        .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
    }

    private var addButton: some View {
        Button(action: onAddTapped) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(SemanticColors.onAccent)
                .frame(width: 44, height: 44)
                .background(SemanticColors.accent, in: Circle())
                .frame(maxWidth: .infinity, minHeight: 52)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Добавить")
    }
}
