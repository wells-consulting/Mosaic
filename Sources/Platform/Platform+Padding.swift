//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

extension Platform {

    // MARK: Semantic

    /// Semantic padding scale. Use `Platform.padding(.medium)` for CGFloat contexts
    /// (spacing: parameters, calculated values) and `.mosaicPadding(.medium)` for
    /// SwiftUI `.padding()` call sites.
    ///
    /// Values are platform-aware — tvOS uses larger spacing for comfortable
    /// viewing at a distance on large screens.
    ///
    /// | Step   | iOS | tvOS | Use                                       |
    /// |--------|-----|------|-------------------------------------------|
    /// | xsmall |   4 |    6 | Fine label gaps, badge vertical inset     |
    /// | small  |   8 |   12 | Badge/pill inner padding                  |
    /// | medium |  12 |   16 | Metadata row spacing                      |
    /// | large  |  16 |   24 | Section padding, card region separation   |
    /// | xlarge |  24 |   36 | Form field padding, generous section gaps |
    public enum PaddingSize {
        case xsmall
        case small
        case medium
        case large
        case xlarge
        fileprivate var value: CGFloat {
            #if os(tvOS)
                switch self {
                case .xsmall: 8
                case .small: 12
                case .medium: 16
                case .large: 24
                case .xlarge: 36
                }
            #else
                switch self {
                case .xsmall: 4
                case .small: 8
                case .medium: 12
                case .large: 16
                case .xlarge: 24
                }
            #endif
        }
    }

    /// Returns the points for a padding step.
    public static func padding(_ size: PaddingSize) -> CGFloat {
        size.value
    }

    // MARK: Constants

    /// Padding for a specific job, where a named step would not say enough.
    public enum PaddingContext {
        /// Vertical padding from the header bar to the top of the grid.
        case headerbarToGrid
        /// Gap between an inline icon/symbol and its adjacent text. 8pt.
        case iconLabelGap
        /// Space below a section heading label, between the heading and
        /// the shelf or grid that follows it. 8pt.
        case sectionHeadingBottomGap
        /// Space above a section heading label that opens a new group of
        /// content (e.g. "Performers", "Studios" in detail views). 32pt.
        case sectionHeadingTopGap
        /// Bottom padding below a section label, before the first row in that section.
        case settingsSectionBottom
        /// Trailing clearance a scrolling settings page reserves so the overlay
        /// scroll indicator can't sit on top of content. 4pt.
        case settingsScrollClearance
        /// Vertical padding inside settings row buttons and text fields.
        case settingsVerticalRow
        /// Tight gap between closely-related siblings (label + sublabel,
        /// badge + value, icon + caption). 4pt.
        case tightGap
        /// Vertical padding inside interactive row and button components. 16pt.
        case verticalRow
        /// Vertical space between major content sections. 20pt.
        case verticalSectionTop

        fileprivate var value: CGFloat {
            switch self {
            case .headerbarToGrid: 24
            case .iconLabelGap: 8
            case .sectionHeadingBottomGap: 8
            case .sectionHeadingTopGap: 32
            case .settingsSectionBottom: 4
            case .settingsScrollClearance: 4
            case .settingsVerticalRow: 29
            case .tightGap: 4
            case .verticalRow: 16
            case .verticalSectionTop: 20
            }
        }
    }

    /// Returns the points for a padding context.
    public static func padding(_ context: PaddingContext) -> CGFloat {
        context.value
    }
}

// MARK: - View Extensions (Relative Size)

public extension View {

    /// Pads the view by a step in the shared scale.
    func mosaicPadding(
        _ edges: Edge.Set = .all,
        _ size: Platform.PaddingSize,
    ) -> some View {
        padding(edges, Platform.padding(size))
    }

    /// Pads every edge by a step in the shared scale.
    func mosaicPadding(
        _ size: Platform.PaddingSize,
    ) -> some View {
        padding(Platform.padding(size))
    }
}

// MARK: - View extensions (Context)

public extension View {

    /// Pads the view by the value for a named context.
    func mosaicPadding(
        _ edges: Edge.Set = .all,
        _ context: Platform.PaddingContext,
    ) -> some View {
        padding(edges, context.value)
    }

    /// Insets page content by the platform's content inset: 32pt on iPad and
    /// 16pt on a phone.
    ///
    /// Put it on the content, not on a `TabView`. Padding the `TabView` itself
    /// would inset its bar. A tvOS view adds horizontal padding.
    func mosaicContentInsetPadding(_ edges: Edge.Set = .horizontal) -> some View {
        #if os(iOS) || os(macOS)
            modifier(ContentInsetPaddingModifier(edges: edges))
        #else
            self
        #endif
    }

    /// Adds the 60pt modal inset on tvOS. No-op elsewhere.
    func mosaicModalContentInsetPadding(_ edges: Edge.Set = .horizontal) -> some View {
        #if os(tvOS)
            padding(edges, 60)
        #else
            self
        #endif
    }

    /// Keeps an iOS settings page in its centered column and adds a small
    /// horizontal inset on macOS. No-op on tvOS.
    func mosaicSettingsContentInsetPadding() -> some View {
        #if os(iOS)
            modifier(SettingsContentInsetPaddingModifier())
        #elseif os(macOS)
            mosaicPadding(.horizontal, .small)
        #else
            self
        #endif
    }

    // MARK: Focus Padding

    /// On tvOS, provides necessary padding for the focus scale effect not to clip in
    /// a grid view. Place this on the grid itself inside the scroll view.
    func mosaicFocusPadding(
        _ edges: Edge.Set = .top
    ) -> some View {
        #if os(tvOS)
            padding(edges, 20)
        #else
            self
        #endif
    }
}

// MARK: - Private modifiers

#if os(iOS) || os(macOS)
    /// Applies a 32pt content inset on iPad and a narrower 16pt on iPhone,
    /// so the same call site reads correctly on both form factors.
    private struct ContentInsetPaddingModifier: ViewModifier {

        @Environment(\.layout) private var layout

        let edges: Edge.Set

        func body(content: Content) -> some View {
            content.padding(edges, layout.widthConstrained ? 16 : 32)
        }
    }
#endif

#if os(iOS)
    /// On iPhone (compact) adds 16pt horizontal inset so sub-pages don't bleed to the
    /// screen edge. On iPad constrains content to 600pt and centers it.
    private struct SettingsContentInsetPaddingModifier: ViewModifier {

        func body(content: Content) -> some View {
            content
                .modifier(SettingsColumnModifier())
        }
    }
#endif
