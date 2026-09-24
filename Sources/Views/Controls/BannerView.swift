//
// the app – Your Stash, beautifuly rendered
// Copyright 2025-2026 Wells Consulting. All rights reserved.
//

import Motley
import SwiftUI

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
