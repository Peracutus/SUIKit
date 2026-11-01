import SwiftUI

public struct OutlinedCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let stroke: Color
    private let background: Color
    private let content: Content

    public init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 18,
        stroke: Color = Color(red: 0.90, green: 0.91, blue: 0.92),
        background: Color = .white,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.stroke = stroke
        self.background = background
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity)
            .background(background, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(stroke, lineWidth: 1)
            }
    }
}
