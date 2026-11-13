//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A detailed error view with an icon, title, summary, optional details,
/// optional diagnostics, and one or more action buttons.
///
/// Generic over an `Action` type that conforms to `RawRepresentable<String> & Hashable`.
/// Each action case becomes a button whose label is the raw value. Up to 3 actions are supported.
///
/// When the underlying error is a URLError, diagnostics are formatted as a concise
/// human-readable summary. The raw dump is still accessible via a "Technical Details"
/// button that opens a scrollable sheet.
///
/// `onAppear`/`onDisappear` let a caller hook host-app-specific side effects (e.g.
/// suppressing a reachability banner while a full-screen error is presented) without
/// this view knowing anything about the host app.
public struct ErrorView<Action: RawRepresentable & Hashable>: View where Action.RawValue == String {

    // MARK: - Fields

    private let title: String
    private let summary: String
    private let details: String?
    private let diagnostics: String?
    private let rawDiagnostics: String?
    private let actions: [Action]
    private let onAppear: (() -> Void)?
    private let onDisappear: (() -> Void)?
    private let onAction: (Action) -> Void

    // MARK: - State

    @State private var showingRawDiagnostics = false

    // MARK: - Initializers

    public init(
        error: any Error,
        title: String,
        options: ErrorDescriptionOptions,
        actions: [Action],
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil,
        onAction: @escaping (Action) -> Void,
    ) {
        self.title = title
        let motleyError = error as? (any MotleyError)
        self.summary = motleyError?.summary ?? error.localizedDescription
        self.details = motleyError?.details
        self.actions = Array(actions.prefix(3))
        self.onAppear = onAppear
        self.onDisappear = onDisappear
        self.onAction = onAction
        let raw = error.describe(options: options)
        let formatted = error.urlErrorSummary
        self.diagnostics = formatted ?? raw
        self.rawDiagnostics = formatted != nil ? raw : nil
    }

    public init(
        title: String?,
        message: Message,
        actions: [Action],
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil,
        onAction: @escaping (Action) -> Void,
    ) {
        self.title = title ?? message.title ?? message.kind.title
        self.summary = message.summary
        self.details = message.details
        self.diagnostics = nil
        self.rawDiagnostics = nil
        self.actions = Array(actions.prefix(3))
        self.onAppear = onAppear
        self.onDisappear = onDisappear
        self.onAction = onAction
    }

    public init(
        title: String,
        summary: String,
        actions: [Action],
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil,
        onAction: @escaping (Action) -> Void,
        details: String? = nil,
    ) {
        self.title = title
        self.summary = summary
        self.details = details
        self.diagnostics = nil
        self.rawDiagnostics = nil
        self.actions = Array(actions.prefix(3))
        self.onAppear = onAppear
        self.onDisappear = onDisappear
        self.onAction = onAction
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                titleView
                descriptionView
                diagnosticsView
                buttonsArea
            }
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { onAppear?() }
        .onDisappear { onDisappear?() }
        .sheet(isPresented: $showingRawDiagnostics) {
            RawDiagnosticsSheet(text: rawDiagnostics ?? "")
        }
    }

    // MARK: - Subviews

    private var titleView: some View {
        HStack(spacing: Platform.spacing(.medium)) {
            Image(.exclamationmark_triangle_fill)
                .font(.title2)
                .foregroundStyle(PaletteStore.shared.current.errorLabel)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .mosaicEnableTextSelection()
            Spacer()
        }
        .mosaicPadding(.medium)
        .glassEffect(
            .regular.tint(PaletteStore.shared.current.errorTint.opacity(0.25)),
            in: .rect(cornerRadius: Platform.cornerRadius(.large))
        )
        .mosaicPadding(.bottom, .small)
    }

    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: Platform.spacing(.xsmall)) {
            Text(summary)
                .multilineTextAlignment(.leading)
                .mosaicEnableTextSelection()
            if let details {
                Text(details)
                    .multilineTextAlignment(.leading)
                    .mosaicFont(.caption)
                    .foregroundStyle(.secondary)
                    .mosaicEnableTextSelection()
            }
        }
    }

    @ViewBuilder
    private var diagnosticsView: some View {
        if let diagnostics {
            VStack(alignment: .leading) {
                Text("Diagnostics")
                    .mosaicFont(.headline)
                    #if os(tvOS)
                        .foregroundStyle(.tertiary)  // audit: tvOS
                    #else
                        .foregroundStyle(.secondary)
                    #endif
                    .padding(.bottom, 4)
                Text(diagnostics)
                    .mosaicFont(.caption)
                    .mosaicEnableTextSelection()
                    #if os(tvOS)
                        .foregroundStyle(.secondary)
                    #else
                        .foregroundStyle(.primary)
                    #endif
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
        }
    }

    private var buttonsArea: some View {
        VStack(alignment: .leading, spacing: Platform.spacing(.xsmall)) {
            if !actions.isEmpty {
                buttonsView
            }
            if rawDiagnostics != nil {
                Button("Technical Details") { showingRawDiagnostics = true }
                    .buttonStyle(.borderless)
                    #if os(tvOS)
                        .foregroundStyle(.tertiary)  // audit: tvOS
                    #else
                        .foregroundStyle(.secondary)
                    #endif
                    .mosaicFont(.caption)
            }
        }
        // pad-audit: keep — uses Theme.spacing scale (different from Theme.padding)
        .padding(.top, Platform.spacing(.large))
    }

    private var buttonsView: some View {
        VStack(spacing: Platform.spacing(.medium)) {
            ForEach(actions, id: \.self) { action in
                Button(action.rawValue) {
                    onAction(action)
                }
                .mosaicButtonStyle()
            }
        }
    }
}

// MARK: - Single-button convenience

/// A single-action type used when ErrorView needs just one button (e.g. "OK").
public enum ErrorDismissAction: String, Hashable {
    case ok = "OK"
}

extension ErrorView where Action == ErrorDismissAction {

    /// Creates an error view with a single "OK" button.
    public init(
        title: String,
        error: any Error,
        options: ErrorDescriptionOptions,
        buttonText: String = "OK",
        onButtonTapped: @escaping () -> Void,
    ) {
        let motleyError = error as? (any MotleyError)
        self.title = title
        self.summary = motleyError?.summary ?? error.localizedDescription
        self.details = motleyError?.details
        self.actions = [.ok]
        self.onAppear = nil
        self.onDisappear = nil
        self.onAction = { _ in onButtonTapped() }
        let raw = error.describe(options: options)
        let formatted = error.urlErrorSummary
        self.diagnostics = formatted ?? raw
        self.rawDiagnostics = formatted != nil ? raw : nil
    }

    /// Creates an error view with a single "OK" button from a Notice.
    public init(
        message: Message,
        buttonText: String = "OK",
        onButtonTapped: @escaping () -> Void,
    ) {
        self.title = message.title ?? message.kind.title
        self.summary = message.summary
        self.details = message.details
        self.diagnostics = nil
        self.rawDiagnostics = nil
        self.actions = [.ok]
        self.onAppear = nil
        self.onDisappear = nil
        self.onAction = { _ in onButtonTapped() }
    }

    /// Creates an error view with a single "OK" button from raw strings.
    public init(
        title: String,
        summary: String,
        details: String? = nil,
        buttonText: String = "OK",
        onButtonTapped: @escaping () -> Void,
    ) {
        self.title = title
        self.summary = summary
        self.details = details
        self.diagnostics = nil
        self.rawDiagnostics = nil
        self.actions = [.ok]
        self.onAppear = nil
        self.onDisappear = nil
        self.onAction = { _ in onButtonTapped() }
    }
}

#if DEBUG
    private enum PreviewAction: String {
        case retry = "Retry", reset = "Reset sort & filters", settings = "Go to settings"
    }
    #Preview {
        VStack {
            ErrorView(
                error: CancellationError(),
                title: "Error",
                options: [.basic],
                actions: [PreviewAction.retry, PreviewAction.reset, PreviewAction.settings],
                onAction: { _ in }
            )
            .colorScheme(.dark)
            .padding(100)
        }
    }
#endif
