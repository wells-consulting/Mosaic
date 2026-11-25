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

    /// How wide a container is, in the thresholds the layouts use.
    public enum WidthClass: Comparable, Sendable {

        /// Narrower than ``ContainerLayout/regularWidth``.
        case compact

        /// At least ``ContainerLayout/regularWidth`` and narrower than
        /// ``ContainerLayout/wideWidth``.
        case regular

        /// At least ``ContainerLayout/wideWidth``.
        case wide
    }

    /// How much vertical room a container has.
    public enum HeightClass: Comparable, Sendable {

        /// A compact vertical size class, such as a phone in landscape.
        case compact

        /// The usual vertical size class.
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

    /// The measured width in points.
    public var width: CGFloat

    /// The measured height, `0` until known. Scroll view content has no height,
    /// so this is the room the container was given, not what the content needs.
    public var height: CGFloat

    /// The vertical size class the container was measured in.
    public var heightClass: HeightClass

    /// True where a pointer drives the interface. Only the Mac reports one.
    public var hasPointer: Bool

    /// True on tvOS.
    public var isTelevision: Bool

    /// The width class for ``width``.
    public var widthClass: WidthClass {
        Self.widthClass(for: width)
    }

    // MARK: - Initializer

    /// - Parameters:
    ///   - width: The measured width in points.
    ///   - height: The measured height in points. `0` when unknown.
    ///   - heightClass: The vertical size class. Defaults to `.regular`.
    ///   - hasPointer: Whether a pointer drives the interface.
    ///   - isTelevision: Whether this is a tvOS container.
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

    /// Returns the width class for a width in points.
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
