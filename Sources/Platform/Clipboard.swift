//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation

#if os(macOS)
    import AppKit
#endif

/// The system clipboard, where the platform has one without UIKit.
///
/// macOS only for now: the rest hide their Copy affordance. Mosaic has no
/// no-UIKit rule, so iOS could use `UIPasteboard` here later.
public enum Clipboard {

    public static var isAvailable: Bool {
        #if os(macOS)
            true
        #else
            false
        #endif
    }

    public static func copy(_ text: String) {
        #if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
}
