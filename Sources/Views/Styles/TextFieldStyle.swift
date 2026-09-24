//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Applies a pill-shaped filled text field style on iOS matching the filled-row aesthetic.
    /// No-op on tvOS where the default style is already appropriate.
    func mosaicRoundedTextFieldStyle(_ backgroundTint: Color? = nil) -> some View {
        #if os(iOS)
            textFieldStyle(MosaicRoundedTextFieldStyle(backgroundTint: backgroundTint))
        #elseif os(macOS)
            textFieldStyle(.roundedBorder)
        #else
            self
        #endif
    }
}

@MainActor
public struct MosaicRoundedTextFieldStyle: TextFieldStyle {

    @Environment(\.layout) private var layout

    let backgroundTint: Color?

    // swiftlint:disable:next identifier_name
    public func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(.horizontal, layout.widthConstrained ? 16 : 24)
            .frame(minHeight: 44)
            .background(
                Capsule()
                    .fill(backgroundTint ?? .clear),
            )
    }
}
