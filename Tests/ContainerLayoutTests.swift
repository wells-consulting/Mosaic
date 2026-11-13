//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import CoreGraphics
import Mosaic
import Testing

/// The width classes: compact below 500, regular up to 900, wide at 900 and
/// up. These cutoffs were decided on, so the test makes sure they don't
/// change.
struct ContainerLayoutTests {

    @Test func widthClassesMeetAtTheirBoundaries() {
        #expect(ContainerLayout.widthClass(for: 320) == .compact)
        #expect(ContainerLayout.widthClass(for: 361) == .compact)
        #expect(ContainerLayout.widthClass(for: 393) == .compact)
        #expect(ContainerLayout.widthClass(for: 499) == .compact)
        #expect(ContainerLayout.widthClass(for: 500) == .regular)
        #expect(ContainerLayout.widthClass(for: 744) == .regular)
        #expect(ContainerLayout.widthClass(for: 899) == .regular)
        #expect(ContainerLayout.widthClass(for: 900) == .wide)
        #expect(ContainerLayout.widthClass(for: 1024) == .wide)
        #expect(ContainerLayout.widthClass(for: 1400) == .wide)
    }

    @Test func theMeasuredWidthDrivesTheClass() {
        #expect(ContainerLayout(width: 393).widthClass == .compact)
        #expect(ContainerLayout(width: 744).widthClass == .regular)
        #expect(ContainerLayout(width: 1400).widthClass == .wide)
    }

    @Test func theFallbackIsTheWidestLayout() {
        #expect(ContainerLayout.fallback.widthClass == .wide)
    }

    @Test func aContainerWithNoHeightIsRegular() {
        let layout = ContainerLayout(width: 744)

        #expect(layout.height == 0)
        #expect(layout.heightClass == .regular)
    }
}
