//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// The container every settings page is built on: a vertical scroll view
/// holding a stack of `SettingsSection`s separated by the section gap.
///
/// It also owns the page inset: the shared top and horizontal padding, plus the
/// trailing clearance the overlay scroll indicator needs. Pages supply sections
/// and nothing else. Inset chrome that isn't part of a page, such as a setup
/// card above it, mirrors the same values to stay flush with the page below.
public struct SettingsPage<Content: View>: View {

    // MARK: - Fields

    private let content: Content

    // MARK: - Initializer

    /// - Parameter sections: The page's sections, in order.
    public init(@ViewBuilder sections: () -> Content) {
        self.content = sections()
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: Platform.spacing(.xlarge)) {
                content
            }
            // .padding(.trailing, .settingsScrollClearance)  // Prevent trailing scroll from obscuring
            .mosaicPadding(.horizontal, .large)
            .mosaicPadding(.top, .large)
        }
        .mosaicScrollView(.vertical, source: .fixed)
        #if os(tvOS)
            .scrollClipDisabled()
        #endif
        #if os(iOS)
            .clipShape(.rect)
        #endif
    }
}
