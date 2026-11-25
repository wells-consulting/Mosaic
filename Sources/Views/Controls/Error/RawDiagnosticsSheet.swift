//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// Presents arbitrary diagnostic text (e.g. an error chain dump) in a
/// scrollable, selectable text view. Intended for on-demand "Technical
/// Details" disclosure from an error or diagnostics UI.
public struct RawDiagnosticsSheet: View {

    // MARK: - Fields

    let text: String

    // MARK: - State

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer

    /// - Parameter text: The diagnostic text to show.
    public init(text: String) {
        self.text = text
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {  // Navigation stack audit: safe; used in .sheet
            ScrollView {
                Text(text)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    #if !os(tvOS)
                        .textSelection(.enabled)
                    #endif
            }
            .navigationTitle("Technical Details")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            #endif
        }
    }
}
