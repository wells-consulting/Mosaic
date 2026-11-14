//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(macOS)
    import AppKit
    import Mosaic
    import Testing

    @MainActor
    struct DockIconTests {

        /// SwiftUI puts the scene's id at the start of a window's identifier and
        /// adds a suffix of its own, so the main window's prefix is how a
        /// settings window from another scene stays out.
        @Test func onlyTheScenesOwnWindowsCount() {
            let counts = DockIcon.counts(identifierPrefix: "main")

            #expect(counts(window(identifier: "main-AppWindow-1")))
            #expect(!counts(window(identifier: "menuBarSettings-AppWindow-1")))
            #expect(!counts(window(identifier: nil)))
        }

        private func window(identifier: String?) -> NSWindow {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 10, height: 10),
                styleMask: [.borderless],
                backing: .buffered,
                defer: true,
            )
            window.isReleasedWhenClosed = false
            if let identifier {
                window.identifier = NSUserInterfaceItemIdentifier(identifier)
            }
            return window
        }
    }
#endif
