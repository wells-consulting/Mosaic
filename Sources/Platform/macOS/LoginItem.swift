//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(macOS)
    import Foundation
    import Motley
    import Observation
    import ServiceManagement

    /// Whether the app opens at login, as the system reports it.
    public enum LoginItemStatus: Equatable, Sendable {

        case enabled
        case disabled

        /// Registered, but waiting for the person to allow it in System
        /// Settings → General → Login Items. Treated as off.
        case requiresApproval
    }

    /// Wraps `SMAppService.mainApp` so a test can drive the toggle without
    /// registering a real login item.
    public protocol LoginItemControlling: Sendable {

        /// The system's current status.
        var status: LoginItemStatus { get }

        /// Registers the login item.
        func register() throws

        /// Removes the login item.
        func unregister() throws

        /// Opens System Settings on the Login Items pane.
        func openSystemSettings()
    }

    /// The app itself as its login item: no helper, sandbox-safe, and listed
    /// under Login Items where the person can turn it off without the app.
    public struct MainAppLoginItem: LoginItemControlling {

        /// Creates the login item for the main app.
        public init() {}

        /// The system's current status for the main app.
        public var status: LoginItemStatus {
            switch SMAppService.mainApp.status {
            case .enabled:
                .enabled
            case .requiresApproval:
                .requiresApproval
            case .notRegistered, .notFound:
                .disabled
            @unknown default:
                .disabled
            }
        }

        /// Registers the app as a login item.
        public func register() throws {
            try SMAppService.mainApp.register()
        }

        /// Removes the app from the login items.
        public func unregister() throws {
            try SMAppService.mainApp.unregister()
        }

        /// Opens System Settings on the Login Items pane.
        public func openSystemSettings() {
            SMAppService.openSystemSettingsLoginItems()
        }
    }

    /// "Open at login" for a Settings toggle.
    ///
    /// It reads the system's status instead of a stored Bool, because the
    /// person can turn the login item off in System Settings without the app
    /// knowing.
    @MainActor
    @Observable
    public final class LoginItemState {

        /// The system's current status, refreshed after every change.
        public private(set) var status: LoginItemStatus

        @ObservationIgnored private let control: any LoginItemControlling

        @ObservationIgnored private let log: Timber

        /// - Parameters:
        ///   - control: The login item to drive. Pass a fake in tests.
        ///   - log: Where a failed register or unregister is recorded.
        public init(
            control: any LoginItemControlling = MainAppLoginItem(),
            log: Timber = Timber(subsystem: "Mosaic", category: "LoginItem"),
        ) {
            self.control = control
            self.log = log
            self.status = control.status
        }

        /// True when the system says the app opens at login. A login item that
        /// is waiting for approval counts as off.
        public var opensAtLogin: Bool { status == .enabled }

        /// Registers or unregisters, then reads the status back: the system,
        /// not this call, says what happened.
        public func setOpensAtLogin(_ opens: Bool) {
            do {
                if opens {
                    try control.register()
                } else if status != .disabled {
                    try control.unregister()
                }
            } catch {
                log.error(
                    error,
                    while: opens ? "registering the login item" : "unregistering the login item",
                )
            }

            refresh()
        }

        /// Reads the system's status again, for when the person changed it in
        /// System Settings.
        public func refresh() {
            status = control.status
        }

        /// Opens System Settings on the Login Items pane.
        public func openSystemSettings() {
            control.openSystemSettings()
        }
    }
#endif
