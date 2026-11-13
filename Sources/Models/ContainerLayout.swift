//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import CoreGraphics

/// The room a container has, and what it can do, measured by
/// `.mosaicMeasuresContainerLayout()`.
///
/// `DeviceLayout` describes the device once at the root. This describes one
/// container, so a sidebar column and a full window get different answers.
/// Put the modifier on a container root, not a leaf.
public struct ContainerLayout: Equatable, Sendable {

    // MARK: - Classes

    public enum WidthClass: Comparable, Sendable {
        case compact
        case regular
        case wide
    }

    public enum HeightClass: Comparable, Sendable {
        case compact
        case regular
    }

    // MARK: - Constants

    /// Below this width a container is compact, at or above it regular.
    public static let regularWidth: CGFloat = 500

    /// At or above this, a container is wide.
    public static let wideWidth: CGFloat = 900

    /// The width before the first measurement, and in previews with no
    /// `.mosaicMeasuresContainerLayout()`.
    public static let fallback = ContainerLayout(width: 900)

    // MARK: - Properties

    public var width: CGFloat

    /// The measured height, `0` until known. Scroll view content has no height,
    /// so this is the room the container was given, not what the content needs.
    public var height: CGFloat

    public var heightClass: HeightClass

    public var hasPointer: Bool

    public var isTelevision: Bool

    public var widthClass: WidthClass {
        Self.widthClass(for: width)
    }

    // MARK: - Initializer

    public init(
        width: CGFloat,
        height: CGFloat = 0,
        heightClass: HeightClass = .regular,
        hasPointer: Bool = false,
        isTelevision: Bool = false,
    ) {
        self.width = width
        self.height = height
        self.heightClass = heightClass
        self.hasPointer = hasPointer
        self.isTelevision = isTelevision
    }

    // MARK: - Width

    public static func widthClass(for width: CGFloat) -> WidthClass {
        if width >= wideWidth {
            .wide
        } else if width >= regularWidth {
            .regular
        } else {
            .compact
        }
    }
}
