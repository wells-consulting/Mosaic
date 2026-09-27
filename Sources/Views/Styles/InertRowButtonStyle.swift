//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {
    /// Applies `InertRowButtonStyle` on tvOS for informational rows that need
    /// focus for scrolling but are not actionable. No-op on other platforms.
    func mosaicInertRowButtonStyle() -> some View {
        #if os(tvOS)
            buttonStyle(.mosaicInertRow)
        #else
            self
        #endif
    }
}

#if os(tvOS)
    public extension ButtonStyle where Self == MosaicInertRowButtonStyle {
        static var mosaicInertRow: MosaicInertRowButtonStyle {
            .init()
        }
    }

    /// A tvOS button style for informational rows that need focus for scrolling
    /// but are not actionable. Shows a subtle border on focus instead of the
    /// system's raised-pill effect, visually distinguishing read-only content
    /// from interactive buttons.
    public struct MosaicInertRowButtonStyle: ButtonStyle {

        public init() {}

        @Environment(\.isFocused) private var isFocused

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(
                        cornerRadius: Platform.cornerRadius(.large),
                        style: .continuous
                    )
                    .fill(Color.white.opacity(isFocused ? 0.08 : 0.0))
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: Platform.cornerRadius(.large),
                        style: .continuous
                    )
                    .strokeBorder(Color.white.opacity(isFocused ? 0.25 : 0.0), lineWidth: 1)
                )
                .animation(.easeInOut(duration: 0.15), value: isFocused)
        }
    }
#endif
