//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation
import SwiftUI

/// A horizontal progress bar that fills proportionally to `progress` (0.0–1.0).
///
/// Used on scene cards and scene detail views to show playback progress.
public struct ProgressBar: View {

    /// How far the bar is filled, from `0` to `1`.
    public let progress: Double

    /// The gradient stops for the filled part.
    public let colors: [Color]

    /// - Parameters:
    ///   - progress: How far the bar is filled, from `0` to `1`.
    ///   - colors: The gradient stops for the filled part.
    public init(progress: Double, colors: [Color]) {
        self.colors = colors
        self.progress = progress
    }

    public var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width - 20
            let fillWidth = max(25, trackWidth * progress)
            Capsule()
                .fill(Color.black.opacity(0.4))
                .frame(width: trackWidth, height: 14)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .leading,
                                endPoint: .trailing,
                            )
                        )
                        .frame(width: fillWidth, height: 10)
                        .padding(.horizontal, 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .mosaicPadding(.bottom, .small)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(
            max(0, min(1, progress)).formatted(.percent.precision(.fractionLength(0)))
        )
    }
}
