//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public struct SettingsPage<Content: View>: View {

    // MARK: - Fields

    private let content: Content

    // MARK: - Initializer

    public init(@ViewBuilder sections: () -> Content) {
        self.content = sections()
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: Platform.spacing(.xlarge)) {
                content
            }
            .padding(.horizontal, 4)  // Prevent trailing scroll from obscuring
        }
        .scrollView(.vertical, source: .fixed)
        #if os(tvOS)
            .scrollClipDisabled()
        #endif
        #if os(iOS)
            .padding(.top, .large)
            .clipShape(.rect)
        #endif
    }
}
