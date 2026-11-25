//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting. All rights reserved.
//

import Motley
import SwiftUI

/// A tinted glass banner with an icon, a title, a subtitle and optional
/// trailing content.
///
/// The three factories, `success`, `warning` and `error`, cover the usual
/// cases and leave the trailing content empty.
public struct BannerView<Content: View>: View {

    #if os(iOS)
        @Environment(\.layout) private var layout
    #endif

    // MARK: - Fields

    private let symbol: SFSymbol?
    private let tint: Color
    private let title: String
    private let subtitle: String
    private let trailingContent: () -> Content

    // MARK: - Initializer

    /// - Parameters:
    ///   - tint: The color behind the glass.
    ///   - title: The bold first line.
    ///   - subtitle: The second line.
    ///   - leadingSymbol: An icon before the text.
    ///   - trailingContent: A control or status after the text.
    public init(
        tint: Color,
        title: String,
        subtitle: String,
        leadingSymbol: SFSymbol? = nil,
        @ViewBuilder trailingContent: @escaping () -> Content = { EmptyView() },
    ) {
        self.tint = tint
        self.title = title
        self.subtitle = subtitle
        self.symbol = leadingSymbol
        self.trailingContent = trailingContent
    }

    // MARK: - Body

    public var body: some View {
        rowContent
            .mosaicGlassBackground(tint)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var rowContent: some View {
        #if os(iOS)
            if layout.isWide {
                twoColumnView
            } else {
                oneColumnView
            }
        #else
            twoColumnView
        #endif
    }

    @ViewBuilder
    private var twoColumnView: some View {
        HStack(spacing: Platform.spacing(.medium)) {
            if let symbol {
                Image(symbol)
                    .fontWeight(.thin)
                    .symbolRenderingMode(.hierarchical)
                    .mosaicFont(.largeTitle)
                    .foregroundStyle(.primary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            trailingContent()
        }
    }

    private var oneColumnView: some View {
        VStack(alignment: .leading) {
            HStack {
                if let symbol {
                    Image(symbol)
                        .fontWeight(.thin)
                        .symbolRenderingMode(.hierarchical)
                        .mosaicFont(.largeTitle)
                        .foregroundStyle(.primary)
                }
                Spacer()
                trailingContent()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Factory

    /// A green banner for a completed job.
    ///
    /// - Parameters:
    ///   - symbol: The icon. Defaults to `.success`.
    ///   - title: The bold first line.
    ///   - message: The second line.
    ///   - tint: The color behind the glass. Defaults to green.
    public static func success(
        symbol: SFSymbol = .success,
        title: String,
        message: String,
        tint: Color = .green,
    ) -> BannerView where Content == EmptyView {
        BannerView(
            tint: tint,
            title: title,
            subtitle: message,
            leadingSymbol: symbol,
        )
    }

    /// An orange banner for a caution.
    ///
    /// - Parameters:
    ///   - symbol: The icon. Defaults to `.warning`.
    ///   - title: The bold first line.
    ///   - message: The second line.
    ///   - tint: The color behind the glass. Defaults to orange.
    public static func warning(
        symbol: SFSymbol = .warning,
        title: String,
        message: String,
        tint: Color = .orange,
    ) -> BannerView where Content == EmptyView {
        BannerView(
            tint: tint,
            title: title,
            subtitle: message,
            leadingSymbol: symbol,
        )
    }

    /// A red banner for a failure.
    ///
    /// - Parameters:
    ///   - symbol: The icon. Defaults to `.error`.
    ///   - title: The bold first line.
    ///   - message: The second line.
    ///   - tint: The color behind the glass. Defaults to red.
    public static func error(
        symbol: SFSymbol = .error,
        title: String,
        message: String,
        tint: Color = .red,
    ) -> BannerView where Content == EmptyView {
        BannerView(
            tint: tint,
            title: title,
            subtitle: message,
            leadingSymbol: symbol,
        )
    }
}
