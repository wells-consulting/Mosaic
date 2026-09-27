//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A button whose label is a single SF symbol image.
///
/// Centralises icon-only button styling: `accessibilityLabel` is required here
/// so it cannot be accidentally omitted, and `tint` covers the common case of
/// a state-driven foreground color (e.g. a filled vs. outline heart icon).
/// Platform-level visual treatment (glass effect, control size) is applied by
/// the containing layout — `appGlassButton()` on `HeaderBar`, for example.
public struct SymbolButton: View {

    let symbol: SFSymbol
    let role: ButtonRole?
    let accessibilityLabel: String
    let action: () -> Void

    public init(
        _ symbol: SFSymbol,
        role: ButtonRole? = nil,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.symbol = symbol
        self.role = role
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        Button(role: role) {
            action()
        } label: {
            Image(symbol)
                .symbolRenderingMode(.hierarchical)
        }
        .accessibilityLabel(accessibilityLabel)
        .mosaicGlassButtonStyle()
    }
}
