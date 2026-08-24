import SwiftUI

public struct ProgressTrack: View {
    private let progress: Double
    private let color: Color
    private let height: CGFloat

    public init(progress: Double, color: Color, height: CGFloat = 5) {
        self.progress = min(max(progress, 0), 1)
        self.color = color
        self.height = height
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.06))
                Capsule()
                    .fill(color)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: height)
        .accessibilityValue(Text(progress, format: .percent.precision(.fractionLength(0))))
    }
}
