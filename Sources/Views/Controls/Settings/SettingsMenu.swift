//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A vertical menu of settings rows with the platform's menu gap.
public struct SettingsMenu<Content: View>: View {

    // MARK: - Fields

    private let content: Content

    // MARK: - Initializer

    /// - Parameter content: The menu's rows.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: Platform.spacing(.settingsMenu)) {
            content
        }
    }
}
