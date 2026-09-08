//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public extension View {
    func messageAlert(_ message: Binding<Message?>) -> some View {
        modifier(MessageAlertModifier(message: message))
    }
}

private struct MessageAlertModifier: ViewModifier {

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
                    default:
                        Label(message.summary, symbol: message.kind.symbol)
                    }
                } else {
                    Label("No message found", symbol: .questionmark_bubble)
                }
            }
    }
}
