//
//  CategorySelector.swift
//  SUIKit
//
//  Переиспользуемый компонент выбора категории с двумя режимами отображения
//

import SwiftUI

// MARK: - PreferenceKey для отслеживания frame категории

public struct CategoryFramePreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero
    
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - CategorySelector

/// Компонент выбора категории с режимами просмотра и редактирования
public struct CategorySelector: View {
    
    // MARK: - Properties
    
    let categories: [CategoryImageModel]
    @Binding var selectedCategory: CategoryImageModel?
    let isEditMode: Bool
    let onCategoryTap: ((CategoryImageModel) -> Void)?
    
    @State private var selectedCategoryFrame: CGRect? = nil
    
    // MARK: - Constants
    
    private enum Layout {
        static let categoryIconSize: CGFloat = 52
        static let cornerRadius: CGFloat = 9
        static let titleFontSize: CGFloat = 9
        static let spacing: CGFloat = 12
    }
    
    // MARK: - Initialization
    
    public init(
        categories: [CategoryImageModel],
        selectedCategory: Binding<CategoryImageModel?>,
        isEditMode: Bool,
        onCategoryTap: ((CategoryImageModel) -> Void)? = nil
    ) {
        self.categories = categories
        self._selectedCategory = selectedCategory
        self.isEditMode = isEditMode
        self.onCategoryTap = onCategoryTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if isEditMode {
                editModeView
            } else {
                viewModeView
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isEditMode)
    }
    
    // MARK: - View Mode (только выбранная категория)
    
    private var viewModeView: some View {
        Group {
            if let category = selectedCategory {
                CategoryIconView(
                    category: category,
                    isSelected: true,
                    showTitle: false,
                    onTap: nil
                )
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
    }
    
    // MARK: - Edit Mode (горизонтальный список всех категорий)
    
    private var editModeView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Layout.spacing) {
                    ForEach(categories) { category in
                        CategoryIconView(
                            category: category,
                            isSelected: category.id == selectedCategory?.id,
                            showTitle: true,
                            onTap: {
                                handleCategorySelection(category)
                            }
                        )
                        .id(category.id)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.8)),
                            removal: .opacity.combined(with: .scale(scale: 0.8))
                        ))
                    }
                }
                .padding(.horizontal)
                .animation(.easeIn(duration: 0.3), value: categories.map { $0.id })
                .onPreferenceChange(CategoryFramePreferenceKey.self) { frame in
                    if frame.midX > 0 && frame.midY > 0 {
                        selectedCategoryFrame = frame
                    }
                }
            }
            .onChange(of: selectedCategory) { _, newCategory in
                guard let targetId = newCategory?.id else { return }
                if categories.contains(where: { $0.id == targetId }) {
                    withAnimation(.easeInOut) {
                        scrollProxy.scrollTo(targetId, anchor: .center)
                    }
                }
            }
            .onAppear {
                if let selectedId = selectedCategory?.id,
                   categories.contains(where: { $0.id == selectedId }) {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            scrollProxy.scrollTo(selectedId, anchor: .center)
                        }
                    }
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .leading)))
    }
    
    // MARK: - Actions
    
    private func handleCategorySelection(_ category: CategoryImageModel) {
        withAnimation(.easeInOut) {
            selectedCategory = category
        }
        onCategoryTap?(category)
    }
}

// MARK: - CategoryIconView

/// Отдельная view для отображения иконки категории
private struct CategoryIconView: View {
    let category: CategoryImageModel
    let isSelected: Bool
    let showTitle: Bool
    let onTap: (() -> Void)?
    
    private var categoryColor: Color {
        Color(hex: category.iconColor) ?? .gray
    }
    
    private enum Layout {
        static let categoryIconSize: CGFloat = 52
        static let cornerRadius: CGFloat = 9
        static let titleFontSize: CGFloat = 9
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            VStack(spacing: 5) {
                IconBox(
                    icon: category.icon,
                    color: categoryColor,
                    frameSize: Layout.categoryIconSize,
                    cornerRadius: Layout.cornerRadius
                )
                .id("\(category.id)-icon-\(category.icon)-\(category.iconColor)")
                .background(categoryFrameReader)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius)
                        .stroke(
                            isSelected ? Color(hex: "#D5D5D5") ?? Color.gray : Color.clear,
                            lineWidth: 1
                        )
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                )
                
                if showTitle {
                    Text(category.categoryTitle)
                        .font(.custom("Manrope-Medium", size: Layout.titleFontSize))
                        .foregroundColor(isSelected ? .primary : .secondary)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .id("\(category.id)-title-\(category.categoryTitle)")
                        .contentTransition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: category.categoryTitle)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                }
            }
            .padding(.top, showTitle ? 8 : 0)
        }
        .buttonStyle(.plain)
        .disabled(onTap == nil)
    }
    
    @ViewBuilder
    private var categoryFrameReader: some View {
        if isSelected {
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                
                // Используем PreferenceKey для передачи координат
                Color.clear
                    .preference(
                        key: CategoryFramePreferenceKey.self,
                        value: frame
                    )
            }
        }
    }
}
