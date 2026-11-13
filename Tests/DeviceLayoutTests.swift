//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Mosaic
import Testing

// MARK: - DeviceLayout

@Suite("DeviceLayout")
struct DeviceLayoutTests {

    private static let everyCase: [DeviceLayout] = [
        .phoneTall,
        .phoneWide,
        .padTall,
        .padWide,
        .padCompact,
    ]

    @Test("A layout is a phone or a pad, never both")
    func phoneAndPadAreExclusive() {
        for layout in Self.everyCase {
            #expect(layout.isPhone != layout.isPad)
        }
    }

    @Test("Width is tight on a tall phone and a narrow split view")
    func widthConstrained() {
        #expect(DeviceLayout.phoneTall.widthConstrained)
        #expect(DeviceLayout.padCompact.widthConstrained)

        #expect(!DeviceLayout.phoneWide.widthConstrained)
        #expect(!DeviceLayout.padTall.widthConstrained)
        #expect(!DeviceLayout.padWide.widthConstrained)
    }

    @Test("Height is tight on a wide phone only")
    func heightConstrained() {
        #expect(DeviceLayout.phoneWide.heightConstrained)

        for layout in Self.everyCase where layout != .phoneWide {
            #expect(!layout.heightConstrained)
        }
    }

    @Test("Tall and wide describe the content area, so a split column is neither")
    func tallAndWideFollowTheShape() {
        #expect(DeviceLayout.phoneTall.isTall)
        #expect(DeviceLayout.padTall.isTall)
        #expect(DeviceLayout.phoneWide.isWide)
        #expect(DeviceLayout.padWide.isWide)

        #expect(!DeviceLayout.padCompact.isTall)
        #expect(!DeviceLayout.padCompact.isWide)
    }
}
