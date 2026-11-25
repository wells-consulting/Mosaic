//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

// On tvOS: focus-engine highlighting + scale spring.
// On iOS: native button press highlight is sufficient.

extension ColorToken {
    /// Fill behind a focused `OverlayButton` on tvOS. Owned by this control,
    /// not the base palette: apps fill it per scheme through `Palette.app`, and
    /// the accessor below keeps the historical default for schemes that don't.
    public static let overlayNormal = ColorToken("mosaic.overlayNormal")
}

public extension Palette {
    /// Focus fill for `OverlayButton`. Falls back to a translucent
    /// opposite-of-background fill, so palettes without an overlay fill render.
    var overlayNormal: Color {
        color(.overlayNormal)
            ?? Color(
                light: Color.white.opacity(0.80),
                dark: Color.black.opacity(0.80)
            )
    }
}

/// Icon + label button used in player overlay controls and detail view action bars.
///
/// On tvOS, gains a focus-engine highlight with a scale spring. On iOS the
/// native button press highlight is sufficient.
public struct OverlayButton: View {

    // MARK: - Properties

    let symbol: SFSymbol
    let label: String
    var tint: Color = .white
    let action: () -> Void

    #if os(tvOS)
        @FocusState private var focused: Bool
    #endif

    // MARK: - Initializer

    /// - Parameters:
    ///   - symbol: The icon above the label.
    ///   - label: The text below the icon.
    ///   - tint: The symbol and text color. Defaults to white.
    ///   - action: What the button runs when pressed.
    public init(
        symbol: SFSymbol,
        label: String,
        tint: Color = .white,
        action: @escaping () -> Void,
    ) {
        self.symbol = symbol
        self.label = label
        self.tint = tint
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            VStack(spacing: Platform.spacing(.small)) {
                Image(symbol)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundStyle(iconTint)
                Text(label)
                    .mosaicFont(.caption2)
                    .foregroundStyle(labelTint)
            }
            .frame(minWidth: minWidth)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            #if os(tvOS)
                .background(
                    RoundedRectangle(cornerRadius: Platform.cornerRadius(.medium))
                        .fill(focused ? PaletteStore.shared.current.overlayNormal : .clear),
                )
                .scaleEffect(focused ? 1.08 : 1.0)
                .animation(.easeOut(duration: 0.15), value: focused)
            #endif
        }
        .buttonStyle(.mosaicGrid)
        .accessibilityLabel(label)
        #if os(tvOS)
            .focused($focused)
        #endif
    }

    // MARK: - Computed Properties

    #if os(tvOS)
        private var iconTint: Color { focused ? .primary : tint }
        private var labelTint: Color { focused ? .primary : .white.opacity(0.8) }
        private var iconSize: CGFloat { 28 }
        private var minWidth: CGFloat { 70 }
    #else
        private var iconTint: Color { tint }
        private var labelTint: Color { .white.opacity(0.8) }
        private var iconSize: CGFloat { 22 }
        private var minWidth: CGFloat { 50 }
    #endif
}
