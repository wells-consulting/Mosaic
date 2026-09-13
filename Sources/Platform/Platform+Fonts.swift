//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public enum PlatformFont {
    case badge
    case body
    case callout
    case caption
    case caption2
    case footnote
    case headline
    case largeTitle
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
    func platformFont(_ name: PlatformFont) -> some View {
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
    func fieldLabelStyle() -> some View {
        platformFont(.caption2)
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

        public init(compactFont: Font, regularFont: Font) {
            self.compactFont = compactFont
            self.regularFont = regularFont
        }

        public func body(content: Content) -> some View {
            content.font(layout.widthConstrained ? compactFont : regularFont)
        }
    }
#endif
