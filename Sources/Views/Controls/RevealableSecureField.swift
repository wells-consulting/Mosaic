//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A secure text field with a toggle button to reveal or hide the value.
public struct RevealableSecureField: View {

    // MARK: - Fields

    private let label: String
    @Binding private var text: String

    // MARK: - State

    @State private var isRevealed = false

    // MARK: - Initializer

    /// - Parameters:
    ///   - label: The field's placeholder.
    ///   - text: The text being edited.
    public init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        #if os(tvOS)
            HStack(alignment: .center, spacing: Platform.spacing(.medium)) {
                textField
                Button {
                    isRevealed.toggle()
                } label: {
                    Label(
                        isRevealed ? "Hide" : "Show",
                        symbol: isRevealed ? .eye_slash : .eye,
                    )
                }
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
        #else
            textField
                .overlay(alignment: .trailing) {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(isRevealed ? .eye_slash : .eye)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .mosaicPadding(.trailing, .medium)
                    .accessibilityLabel(isRevealed ? "Hide password" : "Show password")
                }
        #endif
    }

    // MARK: - Subviews

    @ViewBuilder
    private var textField: some View {
        if isRevealed {
            TextField(label, text: $text)
                .autocorrectionDisabled()
                .mosaicNoAutocapitalization()
        } else {
            SecureField(label, text: $text)
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var password = "ItsASecret!"
        VStack {
            RevealableSecureField("Password", text: $password)
        }
        .frame(width: 800)
        .mosaicPadding(.xlarge)
        .background(.white.opacity(0.25))
    }
#endif
