//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(macOS)
    import AppKit

    /// Shows or hides the Dock icon.
    ///
    /// In menu-bar-only mode it's hidden while no window is open, and shown
    /// while one is, so the window gets the menu bar and ⌘-Tab like any other
    /// app's. Which windows count is the caller's call: an app with a settings
    /// window that shouldn't bring the icon back passes `counts`.
    @MainActor
    public enum DockIcon {

        /// Shows or hides the Dock icon for the current window set.
        ///
        /// - Parameters:
        ///   - hidesDockIcon: Whether the app wants a menu-bar-only mode.
        ///   - counts: Which windows should bring the icon back. The default
        ///     counts every window that can become main.
        public static func update(
            hidesDockIcon: Bool,
            counts: @MainActor (NSWindow) -> Bool = { $0.canBecomeMain },
        ) {
            let hasWindow = NSApp.windows.contains { $0.isVisible && counts($0) }
            let policy = policy(hidesDockIcon: hidesDockIcon, hasWindow: hasWindow)

            guard NSApp.activationPolicy() != policy else {
                return
            }

            if policy == .accessory && NSApp.isActive {
                activateFrontAppOnThisDesktop()
            }

            NSApp.setActivationPolicy(policy)
        }

        /// Returns the activation policy for a menu-bar preference and a window
        /// count, without touching the app.
        ///
        /// - Parameters:
        ///   - hidesDockIcon: Whether the app wants a menu-bar-only mode.
        ///   - hasWindow: Whether a window that counts is visible.
        public nonisolated static func policy(
            hidesDockIcon: Bool,
            hasWindow: Bool,
        ) -> NSApplication.ActivationPolicy {
            hidesDockIcon && !hasWindow ? .accessory : .regular
        }

        /// A `counts` for `update(hidesDockIcon:counts:)` that takes the windows
        /// of one scene.
        ///
        /// SwiftUI sets a window's identifier from the scene's id and adds a
        /// suffix, so this matches the start and not the whole
        /// thing.
        public nonisolated static func counts(
            identifierPrefix prefix: String,
        ) -> @MainActor (NSWindow) -> Bool {
            { window in
                window.identifier?.rawValue.hasPrefix(prefix) == true
            }
        }

        /// Hiding the Dock icon while we're the active app makes macOS pick
        /// another app to activate, and it can pick one on another desktop and
        /// swipe over to it. So we hand off to the app whose window is in front
        /// on this desktop first.
        ///
        /// Not sure this covers every case. An empty desktop falls back to
        /// Finder, and we haven't seen what that does.
        private static func activateFrontAppOnThisDesktop() {
            let ownPID = ProcessInfo.processInfo.processIdentifier

            // On-screen windows are only the current desktop's, front to back.
            let windows =
                CGWindowListCopyWindowInfo(
                    [.optionOnScreenOnly, .excludeDesktopElements],
                    kCGNullWindowID,
                ) as? [[String: Any]] ?? []

            let front = windows.lazy
                .filter { ($0[kCGWindowLayer as String] as? Int) == 0 }
                .compactMap { $0[kCGWindowOwnerPID as String] as? pid_t }
                .filter { $0 != ownPID }
                .compactMap { NSRunningApplication(processIdentifier: $0) }
                .first { $0.activationPolicy == .regular }

            let next =
                front
                ?? NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder").first

            guard let next else {
                return
            }

            NSApp.yieldActivation(to: next)
            next.activate()
        }
    }
#endif
