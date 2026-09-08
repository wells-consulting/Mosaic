//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

// MARK: - ButtonGroup

/// A horizontal cluster of controls rendered inside a single shared Liquid Glass pill,
/// matching the grouped-control treatment the system applies to `ToolbarItemGroup` on iOS 26.
///
/// Use this anywhere a small cluster of controls should read as one capsule:
/// - `HeaderBar`'s actions / sort / status slots
/// - Image viewer / video player on-screen overlays where the system toolbar is hidden
/// - Any custom inline control row
///
/// Children opt out of their own per-control glass automatically via the
/// `isInsideButtonGroup` environment value — drop `SymbolButton`, a `Menu` styled with
/// `appGlassMenuStyle()`, or any `appGlassButton()` caller directly inside `content` and they
/// render as plain icons / labels inside the pill.
///
/// `spacing` controls inter-control gaps (matches Images/system toolbar density):
/// - `.medium` (default): standard cluster density, works for both icon-only and text+icon mixes
/// - `.large`: when you want extra breathing room (rare — usually density should match the tab bar)
/// - `.small` or `.xsmall`: tightly packed status indicators
///
/// No-op on tvOS, which uses its own focus treatments.
public struct ButtonGroup<Content: View>: View {

    #if os(iOS)
        @Environment(\.layout) private var layout
    #endif

    public enum ContentSpacing {
        case none
        case standard
    }

    private let contentSpacing: ContentSpacing

    #if os(iOS)
        private let glass: Glass
    #endif

    private let content: () -> Content

    #if os(iOS)
        public init(
            spacing: ContentSpacing = .standard,
            glass: Glass? = nil,
            @ViewBuilder content: @escaping () -> Content,
        ) {
            self.content = content
            self.glass = glass ?? .regular.tint(.white.opacity(0.08))
            self.contentSpacing = spacing
        }
    #else
        public init(
            spacing: ContentSpacing = .standard,
            @ViewBuilder content: @escaping () -> Content,
        ) {
            self.content = content
            self.contentSpacing = spacing
        }
    #endif

    private var spacing: CGFloat {
        switch contentSpacing {
        case .none:
            0
        case .standard:
            #if os(iOS)
                Platform.spacing(layout.widthConstrained ? .medium : .large)
            #else
                Platform.spacing(.small)
            #endif
        }
    }

    public var body: some View {
        #if os(iOS)
            HStack(spacing: spacing) {
                content()
            }
            // Render any raw `Button` inside the group as borderless so we don't
            // get a nested glass surface inside the pill. `SymbolButton` + `appButtonStyle`
            // already pick this up via the env; this covers callers that pass plain
            // `Button`s directly (e.g. `SelectionHeaderBar`).
            .buttonStyle(.borderless)
            // Match Apple's toolbar convention: body-size text and symbols. No
            // `imageScale` boost — SF Symbols inherit the body font height so the
            // pill reads as supporting chrome, not a headline-weight surface.
            .font(.body)
            // Pin a minimum height so pills with mixed content (text + icons) match
            // icon-only pills. SF Symbols at body are ~17pt; text line height is ~22pt.
            .frame(minHeight: 22)
            .environment(\.insideButtonGroup, true)
            // 12pt horizontal + 14pt vertical mirrors Apple's `.glass(...).controlSize(.large)`
            // button chrome so a grouped pill is the same height as a standalone
            // `appGlassButton()` button (~44pt total). Standalone menus use the same
            // 14pt vertical via `AdaptiveMenuStyleModifier` for visual parity.
            .platformPadding(.horizontal, .large)
            .padding(.vertical, 12)
            // `.regular` glass alone disappears on the app's flat dark gradient,
            // so apply a faint white tint for visibility. A lower opacity than the
            // system selected-tab indicator (which sits on a contained darker tab-bar
            // surface) keeps the pill from reading as a solid lighter capsule here.
            .glassEffect(glass, in: Capsule())
        #else
            HStack(spacing: spacing) {
                content()
            }
        #endif
    }
}

#if DEBUG
    #Preview("Icon trio") {
        ButtonGroup {
            SymbolButton(.checkmark_circle, accessibilityLabel: "Select") {}
            SymbolButton(.document_on_document, accessibilityLabel: "Find duplicates") {}
            SymbolButton(.play_fill, accessibilityLabel: "Play all") {}
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }

    #Preview("Sort group (menu + direction)") {
        ButtonGroup {
            Menu("Date Added") {
                Button("Date Added") {}
                Button("Title") {}
            }
            SymbolButton(.arrow_down, accessibilityLabel: "Sort direction") {}
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }

    #Preview("Single button") {
        ButtonGroup {
            SymbolButton(.bookmark, accessibilityLabel: "Bookmark") {}
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
#endif
