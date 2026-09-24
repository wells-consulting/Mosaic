//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// Renders linear `ProgressView`s as a gradient-filled capsule, matching
/// the look of the card `ProgressBar` instead of the system's flat tint.
public extension ProgressViewStyle where Self == MosaicGradientProgressViewStyle {
    static func mosaicGradient(
        _ colors: [Color] = PaletteStore.shared.current.progress,
        trackHeight: CGFloat = 6
    ) -> MosaicGradientProgressViewStyle {
        MosaicGradientProgressViewStyle(trackHeight: trackHeight, colors: colors)
    }
}

public struct MosaicGradientProgressViewStyle: ProgressViewStyle {

    let trackHeight: CGFloat
    let colors: [Color]

    public func makeBody(configuration: Configuration) -> some View {
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
