//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// One named color scheme, mapping semantic roles to concrete `Color` values.
///
/// Roles that adapt to light/dark appearance should build their value with
/// `Color(light:dark:)`, mirroring asset-catalog adaptivity. Publish the active
/// palette through `PaletteStore` — SwiftUI tracks reads during `body`
/// evaluation, so swapping palettes invalidates every view that read a token.
///
///     struct Midnight: Palette {
///         let id = "mosaic.midnight"
///         let name = "Midnight"
///         var cardFill = Color(light: Color(red: 0.95, green: 0.95, blue: 0.95),
///                              dark: Color(red: 0.12, green: 0.12, blue: 0.14))
///         // ...
///     }
public protocol Palette: Sendable {

    /// Stable identifier used for persistence across launches.
    var id: String { get }

    /// Localized display name for the settings picker.
    var name: String { get }

    // MARK: - Surfaces

    /// Filled surface of cards and panels.
    var cardFill: Color { get }

    /// Hairline border around cards and panels.
    var cardBorder: Color { get }

    /// Border around media thumbnails in grids.
    var cardThumbnailBorder: Color { get }

    /// Background of rows in lists and forms.
    var rowBackground: Color { get }

    /// Fill behind overlay controls such as buttons and badges.
    var overlayNormal: Color { get }

    // MARK: - Neutral button surfaces

    /// Top gradient stop of regular neutral buttons.
    var neutralRegularTop: Color { get }

    /// Bottom gradient stop of regular neutral buttons.
    var neutralRegularBottom: Color { get }

    /// Top gradient stop of prominent neutral buttons.
    var neutralProminentTop: Color { get }

    /// Bottom gradient stop of prominent neutral buttons.
    var neutralProminentBottom: Color { get }

    /// Label text on neutral button surfaces.
    var neutralLabel: Color { get }

    // MARK: - Tints

    var accentTint: Color { get }

    /// Tint for bar chrome that sits under system-drawn labels — the tab-bar
    /// selection fill. Defaults to `accentTint`; schemes may deepen it so the
    /// system's white-on-pill highlight stays legible where a bright accent
    /// would shout.
    var tabBarTint: Color { get }

    var errorTint: Color { get }

    var warningTint: Color { get }

    var successTint: Color { get }

    // MARK: - Labels

    var accentLabel: Color { get }

    var errorLabel: Color { get }

    var warningLabel: Color { get }

    // MARK: - Gradients

    /// Center → edge radial vignette painted behind content.
    var vignette: [Color] { get }

    /// Start → end colors of linear progress bars.
    var progress: [Color] { get }
}

extension Palette {
    var tabBarTint: Color { accentTint }
}
