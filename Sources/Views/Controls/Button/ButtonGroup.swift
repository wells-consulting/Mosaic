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
/// - A header's actions, sort and status slots
/// - Image viewer / video player on-screen overlays where the system toolbar is hidden
/// - Any custom inline control row
///
/// Children opt out of their own per-control glass automatically through the
/// `insideButtonGroup` environment value. Drop `SymbolButton`, a `Menu` styled
/// with `mosaicGlassMenuContent()`, or any `mosaicGlassButtonStyle()` caller
/// directly inside `content`, and they render as plain icons or labels inside
/// the pill.
///
/// `spacing` controls the gap between controls. `.standard` matches the system
/// toolbar density. `.none` packs the controls against each other.
///
/// No-op on tvOS, which uses its own focus treatments.
public struct ButtonGroup<Content: View>: View {

    #if os(iOS)
        @Environment(\.layout) private var layout
    #endif

    /// The gap between controls in the pill.
    public enum ContentSpacing {

        /// No gap. Use for controls that read as one unit.
        case none

        /// The system toolbar gap.
        case standard
    }

    private let contentSpacing: ContentSpacing

    #if os(iOS)
        private let glass: Glass
    #endif

    private let content: () -> Content

    #if os(iOS)
        /// - Parameters:
        ///   - spacing: The gap between controls. Defaults to `.standard`.
        ///   - glass: The pill's glass. Defaults to a faint white tint.
        ///   - content: The controls in the group.
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
        /// - Parameters:
        ///   - spacing: The gap between controls. Defaults to `.standard`.
        ///   - content: The controls in the group.
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
            // get a nested glass surface inside the pill. `SymbolButton` + `mosaicButtonStyle`
            // already pick this up through the environment; this covers callers that pass plain
            // `Button`s directly, for example in a header.
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
            // `mosaicGlassButtonStyle()` button (~44pt total). Standalone menus use the same
            // 14pt vertical via `AdaptiveMenuStyleModifier` for visual parity.
            .mosaicPadding(.horizontal, .large)
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
