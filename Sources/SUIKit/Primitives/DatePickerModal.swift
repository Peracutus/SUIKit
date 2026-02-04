//
//  DatePickerModal.swift
//  SUIKit
//
//  Переиспользуемый модальный компонент выбора даты
//

import SwiftUI

// MARK: - DatePickerModal

/// Модальное окно выбора даты с затемненным фоном
public struct DatePickerModal: View {
    
    // MARK: - Properties
    
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    let title: String
    let displayedComponents: DatePickerComponents
    
    // MARK: - Constants
    
    private enum Layout {
        static let maxWidth: CGFloat = 600
        static let cornerRadius: CGFloat = 16
        static let pickerCornerRadius: CGFloat = 12
        static let verticalPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let headerTopPadding: CGFloat = 20
        static let pickerHorizontalPadding: CGFloat = 12
        static let spacing: CGFloat = 12
        static let iconSpacing: CGFloat = 8
        static let shadowRadius: CGFloat = 10
        static let shadowY: CGFloat = -2
    }
    
    private enum Typography {
        static let dateFontSize: CGFloat = 14
        static let buttonFontSize: CGFloat = 16
    }
    
    private enum Colors {
        static let overlayOpacity: CGFloat = 0.35
        static let actionColor = Color(hex: "#3D3D3D") ?? Color.primary
        static let buttonTextColor = Color.black
    }
    
    // MARK: - Initialization
    
    public init(
        isPresented: Binding<Bool>,
        selectedDate: Binding<Date>,
        title: String = "Готово",
        displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
    ) {
        self._isPresented = isPresented
        self._selectedDate = selectedDate
        self.title = title
        self.displayedComponents = displayedComponents
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            if isPresented {
                // Затемненный фон
                Color.black.opacity(Colors.overlayOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                    .zIndex(10)
                
                // Модальное окно с выбором даты
                datePickerContent
                    .frame(maxWidth: Layout.maxWidth)
                    .padding(.vertical, Layout.verticalPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                            .fill(Color(uiColor: .systemBackground))
                            .shadow(radius: Layout.shadowRadius, y: Layout.shadowY)
                    )
                    .padding(.horizontal, Layout.horizontalPadding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(11)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
    
    // MARK: - Date Picker Content
    
    private var datePickerContent: some View {
        VStack(spacing: Layout.spacing) {
            // Header с отображением даты и кнопкой "Готово"
            headerView
                .padding(.horizontal)
                .padding(.top, Layout.headerTopPadding)
            
            // Основной DatePicker
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: displayedComponents
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
            .cornerRadius(Layout.pickerCornerRadius)
            .padding(.horizontal, Layout.pickerHorizontalPadding)
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            Spacer()
            
            // Иконка календаря и отформатированная дата
            HStack(spacing: Layout.iconSpacing) {
                Image(systemName: "calendar")
                    .foregroundColor(Colors.actionColor)
                
                Text(formattedDate)
                    .font(.system(size: Typography.dateFontSize, weight: .medium))
                    .foregroundColor(Colors.actionColor)
            }
            
            Spacer()
            
            // Кнопка "Готово"
            Button(title) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isPresented = false
                }
            }
            .font(.system(size: Typography.buttonFontSize, weight: .semibold))
            .foregroundColor(Colors.buttonTextColor)
            .padding(.trailing, 12)
        }
    }
    
    // MARK: - Formatted Date
    
    private var formattedDate: String {
        if displayedComponents.contains(.hourAndMinute) {
            return selectedDate.formatted(date: .abbreviated, time: .shortened)
        } else {
            return selectedDate.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DatePickerModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var showPicker = true
        @State private var date = Date()
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Selected: \(date.formatted())")
                    
                    Button("Show Picker") {
                        showPicker = true
                    }
                }
                
                DatePickerModal(
                    isPresented: $showPicker,
                    selectedDate: $date
                )
            }
        }
    }
}
#endif
