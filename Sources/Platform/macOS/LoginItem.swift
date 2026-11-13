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

        var status: LoginItemStatus { get }

        func register() throws

        func unregister() throws

        func openSystemSettings()
    }

    /// The app itself as its login item: no helper, sandbox-safe, and listed
    /// under Login Items where the person can turn it off without the app.
    public struct MainAppLoginItem: LoginItemControlling {

        public init() {}

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

        public func register() throws {
            try SMAppService.mainApp.register()
        }

        public func unregister() throws {
            try SMAppService.mainApp.unregister()
        }

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

        public private(set) var status: LoginItemStatus

        @ObservationIgnored private let control: any LoginItemControlling

        @ObservationIgnored private let log = Timber(subsystem: "Mosaic", category: "LoginItem")

        public init(control: any LoginItemControlling = MainAppLoginItem()) {
            self.control = control
            self.status = control.status
        }

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

        public func refresh() {
            status = control.status
        }

        public func openSystemSettings() {
            control.openSystemSettings()
        }
    }
#endif
