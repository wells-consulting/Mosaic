//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Applies a pill-shaped filled text field style on iOS matching the filled-row aesthetic.
    /// No-op on tvOS where the default style is already appropriate.
    func textFieldStyle(_ backgroundTint: Color) -> some View {
        #if os(iOS)
        textFieldStyle(FilledTextFieldStyle(backgroundTint: backgroundTint))
        #else
            self
        #endif
    }
}

#if os(iOS)
    @MainActor
    private struct FilledTextFieldStyle: TextFieldStyle {

        @Environment(\.layout) private var layout

        let backgroundTint: Color

        // swiftlint:disable:next identifier_name
        func _body(configuration: TextField<_Label>) -> some View {
            let hPad: CGFloat = layout.widthConstrained ? 16 : 24
            return
                configuration
                .padding(.horizontal, hPad)
                .frame(minHeight: 44)
                .background(
                    Capsule()
                        .fill(backgroundTint),
                )
        }
    }
#endif
