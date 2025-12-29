//
//  CustomSegmentedControl.swift
//  SUIKit
//
//  Created by Роман Рунов on 28.03.2025.
//

import SwiftUI



struct CustomSegmentedControl: View {
    enum Selection: String, CaseIterable {
        case income = "Income"
        case expense = "Expense"
    }
    
    @Binding var selected: Selection
    
    var body: some View {
        Picker("Transaction Type", selection: $selected) {
            ForEach(Selection.allCases, id: \.self) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

// Usage Example
struct ContentView: View {
    @State private var selectedTab: CustomSegmentedControl.Selection = .income
    
    var body: some View {
        VStack {
            CustomSegmentedControl(selected: $selectedTab)
            
            Text("Selected: \(selectedTab.rawValue)")
                .padding()
            
            // Example of how to use the selection
            if selectedTab == .income {
//                Text("IncomeVgsgsiew()")
            
            } else {
                Text("ExpenseView()")
            }
        }
    }
}

// Preview Provider
struct CustomSegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
