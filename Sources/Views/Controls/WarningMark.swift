//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// The triangle that marks a figure with a problem, explaining it on hover.
///
/// Pair it with `CardPanel(emphasis: .warning)`, which draws the border in the
/// same color.
public struct WarningMark: View {

    /// The border a card draws around a marked figure, in the triangle's color.
    public static var borderColor: Color {
        PaletteStore.shared.current.warningTint.opacity(0.7)
    }

    /// The warning border's width.
    public static let borderWidth: CGFloat = 1.5

    private let explanation: String
    private let prefix: String?

    /// - Parameters:
    ///   - explanation: Why the figure is marked, read on hover and by
    ///     VoiceOver.
    ///   - prefix: What VoiceOver says before the explanation, such as
    ///     "Flagged." Nothing by default.
    public init(explanation: String, prefix: String? = nil) {
        self.explanation = explanation
        self.prefix = prefix
    }

    public var body: some View {
        Image(.exclamationmark_triangle_fill)
            .font(.caption)
            .foregroundStyle(PaletteStore.shared.current.warningLabel)
            .help(explanation)
            .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        guard let prefix else {
            return explanation
        }

        return "\(prefix) \(explanation)"
    }
}
