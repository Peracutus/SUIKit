import SwiftUI

public struct CustomSegmentedControl<SelectionValue: Hashable>: View {
    @Binding var selection: SelectionValue
    let options: [(value: SelectionValue, label: String, icon: String?)]
    
    @Namespace private var animation
    
    public init(
        selection: Binding<SelectionValue>,
        options: [(value: SelectionValue, label: String, icon: String?)]
    ) {
        self._selection = selection
        self.options = options
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                segmentButton(for: option)
            }
        }
        .frame(height: 40)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func segmentButton(for option: (value: SelectionValue, label: String, icon: String?)) -> some View {
        let isSelected = selection == option.value
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selection = option.value
            }
        }) {
            HStack(spacing: 5) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                
                Text(option.label)
                    .font(.system(size: 14, weight: .medium))
                    .lineSpacing(18 - 14)
                    .kerning(-0.08)
            }
            .foregroundColor(isSelected ? .white : .black.opacity(0.5))
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#7D7DDE") ?? .purple)
                            .matchedGeometryEffect(id: "segment", in: animation)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

// Convenience initializer для простых случаев без иконок
extension CustomSegmentedControl {
    public init(
        selection: Binding<SelectionValue>,
        options: [(value: SelectionValue, label: String)]
    ) {
        self._selection = selection
        self.options = options.map { ($0.value, $0.label, nil) }
    }
}
