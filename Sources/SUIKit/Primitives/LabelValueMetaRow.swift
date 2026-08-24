import SwiftUI

public struct LabelValueMetaRow: View {
    private let label: String
    private let value: String
    private let meta: String?

    public init(label: String, value: String, meta: String? = nil) {
        self.label = label
        self.value = value
        self.meta = meta
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            Spacer(minLength: 8)
            if let meta {
                Text(meta)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
