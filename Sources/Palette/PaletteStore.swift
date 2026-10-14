//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Observation
import SwiftUI

/// Holds the app's active color `Palette`, published as a shared singleton.
///
/// Reads of `palette` during SwiftUI `body` evaluation register with Observation
/// tracking, so assigning a new palette invalidates every view that read a token.
/// Tokens therefore resolve statically — `Theme.cardFill` reads
/// `PaletteStore.shared.palette.cardFill` — and stay reactive without an
/// environment injection path.
@MainActor
@Observable
public final class PaletteStore {

    /// Process-wide store. Install the app's concrete palette before the first
    /// frame renders.
    public static let shared = PaletteStore()

    /// The palette currently in effect. Defaults to a neutral placeholder so
    /// token reads never hit an empty store; apps replace it at launch.
    public var current: any Palette = NeutralPalette()

    /// The id of the pristine placeholder shipped by this store, before the
    /// hosting app installs its own palette.
    private static let placeholderPaletteID = NeutralPalette().id

    /// True while `palette` is still the store's placeholder, i.e. the hosting
    /// app hasn't installed its own palette yet.
    private var isUsingPlaceholderPalette: Bool {
        current.id == Self.placeholderPaletteID
    }

    /// Installs `defaultPalette` in place of the placeholder when the hosting
    /// app hasn't made a choice yet. A no-op once any palette is in effect, so a
    /// first-frame default (or earlier explicit install such as a persisted
    /// color-scheme setting) is never overridden.
    public func setDefaultIfUnset(_ defaultPalette: any Palette) {
        guard isUsingPlaceholderPalette else { return }
        current = defaultPalette
    }

    private init() {}
}

/// Neutral grayscale stand-in used only when an app has not installed its own
/// palette. Guarantees first-frame content renders; it is not a product design.
private struct NeutralPalette: Palette {

    let id = "mosaic.neutral"
    let name = "Neutral"

    let cardFill = Color(
        light: Color(red: 1.00, green: 1.00, blue: 1.00),
        dark: Color(red: 0.13, green: 0.13, blue: 0.15)
    )

    let cardBorder = Color(
        light: Color(red: 0.88, green: 0.88, blue: 0.90),
        dark: Color(red: 0.24, green: 0.24, blue: 0.27)
    )

    let rowBackground = Color(
        light: Color(red: 0.96, green: 0.96, blue: 0.97),
        dark: Color(red: 0.10, green: 0.10, blue: 0.12)
    )

    let neutralRegularTop = Color(
        light: Color(red: 0.97, green: 0.97, blue: 0.98),
        dark: Color(red: 0.18, green: 0.18, blue: 0.20)
    )

    let neutralRegularBottom = Color(
        light: Color(red: 0.93, green: 0.93, blue: 0.95),
        dark: Color(red: 0.13, green: 0.13, blue: 0.15)
    )

    let neutralProminentTop = Color(
        light: Color(red: 0.45, green: 0.45, blue: 0.50),
        dark: Color(red: 0.36, green: 0.36, blue: 0.40)
    )

    let neutralProminentBottom = Color(
        light: Color(red: 0.30, green: 0.30, blue: 0.34),
        dark: Color(red: 0.24, green: 0.24, blue: 0.27)
    )

    let neutralLabel = Color(light: .white, dark: .white)

    let accentTint = Color(red: 0.50, green: 0.35, blue: 0.85)
    let errorTint = Color(red: 0.80, green: 0.25, blue: 0.25)
    let warningTint = Color(red: 0.90, green: 0.55, blue: 0.20)
    let successTint = Color(red: 0.25, green: 0.70, blue: 0.40)

    let accentLabel = Color(red: 0.50, green: 0.35, blue: 0.85)

    let errorLabel = Color(
        light: Color(red: 0.80, green: 0.25, blue: 0.25),
        dark: Color(red: 0.95, green: 0.45, blue: 0.45)
    )

    let warningLabel = Color(
        light: Color(red: 0.90, green: 0.55, blue: 0.20),
        dark: Color(red: 0.95, green: 0.70, blue: 0.40)
    )

    let vignette: [Color] = [
        Color(
            light: Color(red: 0.85, green: 0.85, blue: 0.90).opacity(0.45),
            dark: Color(red: 0.30, green: 0.30, blue: 0.40).opacity(0.55)
        ),
        Color(
            light: Color(red: 0.97, green: 0.97, blue: 0.98).opacity(0.00),
            dark: Color(red: 0.06, green: 0.06, blue: 0.08).opacity(0.00)
        ),
    ]

    let progress: [Color] = [
        Color(red: 0.50, green: 0.35, blue: 0.85),
        Color(red: 0.70, green: 0.55, blue: 0.95),
    ]
}
