//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Renders linear `ProgressView`s as a gradient-filled capsule, matching
    /// the look of the card `ProgressBar` instead of the system's flat tint.
    func gradientProgressViewStyle(_ colors: [Color], trackHeight: CGFloat = 6) -> some View {
        progressViewStyle(GradientProgressViewStyle(trackHeight: trackHeight, colors: colors))
    }
}

private struct GradientProgressViewStyle: ProgressViewStyle {

    let trackHeight: CGFloat
    let colors: [Color]

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            let fillWidth = max(
                trackHeight,
                geo.size.width * (configuration.fractionCompleted ?? 0),
            )
            Capsule()
                .fill(Color.primary.opacity(0.15))
                .frame(width: geo.size.width, height: trackHeight)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .leading,
                                endPoint: .trailing,
                            )
                        )
                        .frame(width: fillWidth, height: trackHeight)
                }
        }
        .frame(height: trackHeight)
    }
}
