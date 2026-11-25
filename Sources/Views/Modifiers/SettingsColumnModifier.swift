//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// Keeps an iOS settings page to a centered column: 600pt on iPad, the
    /// width less a 16pt margin on iPhone.
    ///
    /// The inset goes into the safe area, not onto the frame. A scroll view
    /// draws the navigation bar's scroll edge effect across the full width, so
    /// a page framed to 600pt showed a 600pt band under a full-width bar. Safe
    /// area padding leaves the scroll view full width and insets only what it
    /// scrolls; a page with no scroll view is inset the same way.
    ///
    /// ```
    ///  ┌───────────────── nav bar ─────────────────┐
    ///  │░░░░░░░░░░░ scroll edge effect ░░░░░░░░░░░░│  full width
    ///  ├───────────┬───────────────────┬───────────┤
    ///  │   inset   │   600pt column    │   inset   │
    ///  │ (safe     │      rows         │ (safe     │
    ///  │  area)    │                   │  area)    │
    /// ```
    ///
    /// `SettingsList` applies it and so does `mosaicSettingsContentInsetPadding()`,
    /// which wraps most pushed pages. Only the outermost one insets; safe area
    /// padding adds up, so a second would double the margin. For the same
    /// reason, don't pad a settings page's frame from outside: that narrows
    /// the scroll view again.
    struct SettingsColumnModifier: ViewModifier {

        // MARK: - Fields

        static let columnWidth: CGFloat = 600

        // MARK: - State

        @Environment(\.layout) private var layout
        @Environment(\.insideSettingsColumn) private var insideSettingsColumn

        @State private var width: CGFloat = 0

        // MARK: - Body

        func body(content: Content) -> some View {
            if insideSettingsColumn {
                content
            } else {
                content
                    .safeAreaPadding(.horizontal, inset)
                    .environment(\.insideSettingsColumn, true)
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.width
                    } action: { newWidth in
                        width = newWidth
                    }
            }
        }

        // MARK: - Helpers

        private var inset: CGFloat {
            let compactInset = Platform.padding(.large)
            if layout.widthConstrained { return compactInset }
            return max(compactInset, (width - Self.columnWidth) / 2)
        }
    }

#endif
