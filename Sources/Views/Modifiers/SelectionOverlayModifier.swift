//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

// MARK: - View Modifier

public extension View {

    /// Adds a selection indicator overlay and dims unselected cards.
    ///
    /// - Parameters:
    ///   - isSelected: Whether this card is currently selected.
    ///   - isActive: Whether multi-select mode is active. When `false`, the
    ///     modifier is a no-op.
    func mosaicSelectionOverlay(isSelected: Bool, isActive: Bool) -> some View {
        modifier(MosaicSelectionOverlayModifier(isSelected: isSelected, isActive: isActive))
    }
}

private struct MosaicSelectionOverlayModifier: ViewModifier {

    let isSelected: Bool
    let isActive: Bool

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(alignment: .topLeading) {
                    MosaicSelectionIndicator(isSelected: isSelected)
                }
                .opacity(isSelected ? 1.0 : 0.6)
                .animation(.easeInOut(duration: 0.15), value: isSelected)
        } else {
            content
        }
    }
}

// MARK: - Indicator View

/// A circle indicator shown on cards during multi-select mode.
///
/// - **Selected:** Filled checkmark circle (accent-colored).
/// - **Unselected:** Stroked empty circle with translucent fill.
///
/// Positioned at top-leading to avoid collisions with sort badges and
/// download badges at top-trailing.
public struct MosaicSelectionIndicator: View {

    let isSelected: Bool
    var selectedSymbol: SFSymbol = .checkmark_circle_fill
    var unselectedSymbol: SFSymbol?

    public init(
        isSelected: Bool,
        selectedSymbol: SFSymbol = .checkmark_circle_fill,
        unselectedSymbol: SFSymbol? = nil,
    ) {
        self.isSelected = isSelected
        self.selectedSymbol = selectedSymbol
        self.unselectedSymbol = unselectedSymbol
    }

    private var indicatorSize: CGFloat {
        #if os(tvOS)
            32
        #else
            28
        #endif
    }

    public var body: some View {
        ZStack {
            if isSelected {
                Image(selectedSymbol)
                    .foregroundStyle(.primary)
                    .background(
                        Circle()
                            .fill(PaletteStore.shared.current.accentTint)
                            .mosaicPadding(.xsmall),
                    )
            } else {
                if let unselectedSymbol {
                    Image(unselectedSymbol)
                        .background(
                            Circle()
                                .fill(.secondary)
                                .mosaicPadding(.xsmall),
                        )
                } else {
                    Circle()
                        .strokeBorder(.white.opacity(0.6), lineWidth: 2)
                        .background(Circle().fill(.black.opacity(0.3)))
                }
            }
        }
        .font(.system(size: indicatorSize))
        .frame(width: indicatorSize, height: indicatorSize)
        .mosaicPadding(.small)
    }
}
