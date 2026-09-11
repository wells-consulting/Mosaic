//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    // MARK: - URL Field

    /// Configures a text field for URL/hostname entry: disables autocorrection
    /// and (on iOS) disables autocapitalisation and sets the keyboard to `.URL`.
    func urlField() -> some View {
        autocorrectionDisabled()
            #if os(iOS)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
            #endif
    }

    // MARK: - Username Field

    /// Configures a text field for username entry: disables autocorrection
    /// and (on iOS) disables autocapitalisation and sets the content type
    /// to `.username`.
    func usernameField() -> some View {
        autocorrectionDisabled()
            #if os(iOS)
                .textInputAutocapitalization(.never)
                .textContentType(.username)
            #endif
    }

    // MARK: - Server Name Field

    /// Configures a text field for server display-name entry: disables
    /// autocorrection and autocapitalisation.
    func serverNameField() -> some View {
        autocorrectionDisabled()
            .noAutocapitalization()
    }

    // MARK: - No Autocapitalisation

    /// Disables text input autocapitalisation on iOS. No-op on tvOS.
    func noAutocapitalization() -> some View {
        #if os(iOS)
            textInputAutocapitalization(.never)
        #else
            self
        #endif
    }

    // MARK: - Number Pad Keyboard

    /// Applies `.keyboardType(.numberPad)` on platforms with software keyboards.
    func numberPad() -> some View {
        #if os(iOS)
            keyboardType(.numberPad)
        #else
            self
        #endif
    }

}
