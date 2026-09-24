//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation

/// Holds the host app's chrome level, published as a shared singleton.
///
/// Reads of `mode` during SwiftUI `body` evaluation register with Observation
/// tracking, mirroring ``PaletteStore``. Defaults to `.custom`; a host app
/// installs `.native` where its own platform story wants native controls —
/// the app does exactly that for macOS.
@MainActor
@Observable
public final class ChromeStore {

    /// Process-wide store. Install the app's chrome level before the first
    /// frame renders.
    public static let shared = ChromeStore()

    /// The chrome level currently in effect.
    public var current: Chrome = .mosaic

    private init() {}
}
