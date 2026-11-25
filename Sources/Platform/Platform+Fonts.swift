//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A semantic place in the type scale.
///
/// The system text styles answer most calls. The named cases below are for
/// text with a job, where the right size depends on the platform.
public enum PlatformFont {

    /// A small badge label.
    case badge
    case body
    case callout
    case caption
    case caption2
    case footnote
    case headline
    case largeTitle

    /// One line under a control: what a number covers, when it was read, what
    /// a switch does.
    case note

    /// Sentences and paragraphs: a story, a card's explanation, a caveat.
    case prose

    /// A helper line on a settings page.
    case settingsFootnote

    /// An intro paragraph on a settings page.
    case settingsIntro
    case subheadline
    case title
    case title2
    case title3
}

public extension View {

    /// Platform-aware type scale.
    ///
    /// iOS adapts per size class (iPhone compact / iPad regular). macOS and
    /// tvOS use native system text styles — Apple tunes `TextStyle` metrics
    /// per platform (body 13pt on macOS, 40pt on tvOS), so the system scale is
    /// the natural best guess. tvOS stays a separate branch so it can be tuned
    /// up without leaking onto macOS.
    @ViewBuilder
    func mosaicFont(_ name: PlatformFont) -> some View {
        switch name {
        case .badge:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .caption, regularFont: .subheadline))
            #elseif os(macOS)
                font(.caption2)
            #else
                font(.caption2)
            #endif
        case .body:
            font(.body)
        case .callout:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .callout, regularFont: .body))
            #elseif os(macOS)
                font(.callout)
            #else
                font(.callout)
            #endif
        case .caption:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .caption, regularFont: .subheadline))
            #elseif os(macOS)
                font(.caption)
            #else
                font(.caption)
            #endif
        case .caption2:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .caption2, regularFont: .caption))
            #elseif os(macOS)
                font(.caption2)
            #else
                font(.caption2)
            #endif
        case .footnote:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .footnote, regularFont: .subheadline))
            #elseif os(macOS)
                font(.footnote)
            #else
                font(.footnote)
            #endif
        case .headline:
            font(.headline)
        case .largeTitle:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .title, regularFont: .largeTitle))
            #elseif os(macOS)
                font(.largeTitle)
            #else
                font(.largeTitle)
            #endif
        case .note:
            // One line under a control: what a number covers, when it was
            // read, what a switch does. macOS resolves footnote, caption and
            // caption2 all to 10 pt, under the HIG's 11 pt for secondary text,
            // so a note reads callout (12 pt) there instead.
            #if os(macOS)
                font(.callout)
            #else
                font(.caption)
            #endif
        case .prose:
            // Sentences and paragraphs: a story, a card's explanation, a
            // caveat. Every TextStyle is about a quarter smaller on macOS
            // (body is 13 pt against iOS's 17), so prose set in callout or
            // smaller is hard to read on a Mac. Prose gets body there, and
            // keeps callout where the system already sizes it for reading.
            #if os(macOS)
                font(.body)
            #else
                font(.callout)
            #endif
        case .settingsIntro:
            // Intro paragraphs on settings pages. macOS System Settings reads
            // body text, and SwiftUI's native .subheadline/.caption on macOS
            // bottom out at 10-11pt -- smaller than the HIG's 13pt default
            // ("Default size | macOS | 13 pt").
            #if os(macOS)
                font(.body)
            #elseif os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .callout, regularFont: .body))
            #else
                font(.callout)
            #endif
        case .settingsFootnote:
            // Helper / footnote lines on settings pages. iOS keeps caption;
            // macOS bumps to callout so helper text stays readable.
            #if os(macOS)
                font(.callout)
            #elseif os(iOS)
                font(.caption)
            #else
                font(.caption)
            #endif
        case .subheadline:
            #if os(iOS)
                modifier(IOSAdaptiveFont(compactFont: .subheadline, regularFont: .callout))
            #elseif os(macOS)
                font(.subheadline)
            #else
                font(.subheadline)
            #endif
        case .title:
            font(.title)
        case .title2:
            font(.title2)
        case .title3:
            font(.title3)
        }
    }

    // MARK: - Composite Style Modifiers

    /// Field label style: smaller caps, slightly tighter spacing, tertiary color.
    /// Used for field group headings inside detail views (e.g. Timestamp, Source).
    func mosaicFieldLabelStyle() -> some View {
        mosaicFont(.caption2)
            .textCase(.uppercase)
            .kerning(0.8)
            #if os(tvOS)
                .foregroundStyle(.tertiary)  // audit: tvOS
            #else
                .foregroundStyle(.secondary)
            #endif
    }

}

// MARK: - iOS Adaptive Font

#if os(iOS)
    /// Environment-aware font modifier for iOS. Applies `compactFont` on iPhone
    /// (compact horizontal size class) and `regularFont` on iPad.
    public struct IOSAdaptiveFont: ViewModifier {

        @Environment(\.layout) private var layout

        let compactFont: Font
        let regularFont: Font

        /// - Parameters:
        ///   - compactFont: The font for a width-constrained layout, such as an
        ///     iPhone or a narrow split view.
        ///   - regularFont: The font for a regular-width layout.
        public init(compactFont: Font, regularFont: Font) {
            self.compactFont = compactFont
            self.regularFont = regularFont
        }

        public func body(content: Content) -> some View {
            content.font(layout.widthConstrained ? compactFont : regularFont)
        }
    }
#endif
