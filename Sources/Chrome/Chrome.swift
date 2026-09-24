//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Observation
import SwiftUI

/// The kind of chrome a component family applies.
///
/// `.mosaic` renders Mosaic's own look — glass capsules, tinted settings
/// cards. `.native` defers to the host platform's native controls: the layout
/// stays the same, but the OS draws the buttons and rows, which is what lets a
/// general-purpose app (e.g. the app's macOS build) sit comfortably next to
/// System Settings. Host apps pick their mode from their platform story just
/// as they install a palette.
public enum Chrome: Sendable {

    /// Mosaic's custom look — the default, so the media app is untouched.
    case mosaic

    /// The host platform's native controls.
    case native
}
