//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Unified card focus modifier — handles platform differences internally.
    ///
    /// - On iOS: always applies scale + shadow spotlight effect driven by `hasFocus`.
    /// - On tvOS: applies the effect specified by `tvOS`:
    ///   - `.hover` — native `.hoverEffect(.highlight)` raised-card ring, no spotlight.
    ///   - `.spotlight` — spotlight scale + shadow (same as iOS) + `.hoverEffectDisabled()`.
    ///
    /// Use this instead of scattering `#if os(tvOS)` focus conditionals across card views.
    func mosaicCardFocus(
        hasFocus: Bool,
        tvOS: TVOSFocusEffect = .hover,
        scale: CGFloat = 1.03,
    ) -> some View {
        modifier(MosaicCardFocusModifier(hasFocus: hasFocus, tvOSEffect: tvOS, scale: scale))
    }
}

// MARK: - TVOSFocusEffect

/// Controls the tvOS focus visual applied by
/// `mosaicCardFocus(hasFocus:tvOS:scale:)`.
public enum TVOSFocusEffect {
    /// tvOS: native `.hoverEffect(.highlight)` raised-card ring. iOS: spotlight.
    /// Use for cards where the tvOS hover lift is the preferred focus visual.
    case hover
    /// tvOS: spotlight scale + shadow + `.hoverEffectDisabled()`. iOS: spotlight.
    /// Use for cards where the custom scale/glow look is preferred on both platforms.
    case spotlight
}

// MARK: - CardFocusModifier

/// Applies the card focus effect for the current platform.
public struct MosaicCardFocusModifier: ViewModifier {

    let hasFocus: Bool
    let tvOSEffect: TVOSFocusEffect
    let scale: CGFloat

    public func body(content: Content) -> some View {
        #if os(tvOS)
            switch tvOSEffect {
            case .hover:
                content.hoverEffect(.highlight)
            case .spotlight:
                content
                    .scaleEffect(hasFocus ? scale : 1.0)
                    .shadow(color: .primary.opacity(hasFocus ? 0.8 : 0), radius: 6)
                    .shadow(color: .primary.opacity(hasFocus ? 0.4 : 0), radius: 8)
                    .animation(.easeInOut(duration: 0.25), value: hasFocus)
                    .hoverEffectDisabled()
            }
        #else
            content
                .scaleEffect(hasFocus ? scale : 1.0)
                .shadow(color: .primary.opacity(hasFocus ? 0.8 : 0), radius: 6)
                .shadow(color: .primary.opacity(hasFocus ? 0.4 : 0), radius: 8)
                .animation(.easeInOut(duration: 0.25), value: hasFocus)
        #endif
    }
}
