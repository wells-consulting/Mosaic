//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public extension View {

    /// Presents a message as an alert while the binding is not nil, then
    /// clears it when the person taps OK.
    ///
    /// - Parameter message: The message to show.
    func mosaicMessageAlert(_ message: Binding<Message?>) -> some View {
        modifier(MosaicMessageAlertModifier(message: message))
    }
}

private struct MosaicMessageAlertModifier: ViewModifier {

    @Binding var message: Message?

    func body(content: Content) -> some View {
        content
            .alert(
                message?.title ?? message?.kind.title ?? "Alert",
                isPresented: .constant(message != nil),
            ) {
                Button("OK") {
                    message = nil
                }
            } message: {
                if let message {
                    switch message.kind {
                    case .info:
                        Text(message.summary)
                            .mosaicEnableTextSelection()
                    default:
                        if let symbol = message.kind.symbol {
                            Label(message.summary, symbol: symbol)
                                .mosaicEnableTextSelection()
                        } else {
                            Text(message.summary)
                                .mosaicEnableTextSelection()
                        }
                    }
                } else {
                    Label("No message found", symbol: .questionmark_bubble)
                }
            }
    }
}
