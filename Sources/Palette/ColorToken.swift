//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

/// One app-defined color slot, resolvable against any `Palette`.
///
/// The base `Palette` protocol is frozen shared chrome. Apps needing their
/// own semantic colors (a solar app's energy flows, a media app's genres)
/// declare tokens in their own module and read them through
/// `Palette/color(_:)` — no Mosaic edit, no other app touched:
///
///     extension ColorToken {
///         static let solarEnergy = ColorToken("example.solarEnergy")
///     }
///
/// Ids are namespaced per app (`"one.*"`, `"two.*"`) so two apps
/// sharing Mosaic can never collide.
public struct ColorToken: Hashable, Sendable {

    public let id: String

    public init(_ id: String) {
        self.id = id
    }
}
