//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(macOS)
    import AppKit
    import Foundation
    import Mosaic
    import Testing

    /// "Open at login" follows the system's status, and the Dock icon hides
    /// only when menu-bar-only mode has no window to show.
    @MainActor
    struct LoginItemTests {

        private final class FakeControl: LoginItemControlling, @unchecked Sendable {
            var status: LoginItemStatus
            var registers = 0
            var unregisters = 0
            var approvalNeeded = false

            init(status: LoginItemStatus) {
                self.status = status
            }

            func register() throws {
                registers += 1
                status = approvalNeeded ? .requiresApproval : .enabled
            }

            func unregister() throws {
                unregisters += 1
                status = .disabled
            }

            func openSystemSettings() {}
        }

        @Test func theToggleReadsBackWhatTheSystemSays() {
            let control = FakeControl(status: .disabled)
            let state = LoginItemState(control: control)

            state.setOpensAtLogin(true)
            #expect(state.opensAtLogin)

            state.setOpensAtLogin(false)
            #expect(!state.opensAtLogin)
            #expect(control.unregisters == 1)
        }

        @Test func waitingForApprovalReadsAsOff() {
            let control = FakeControl(status: .disabled)
            control.approvalNeeded = true
            let state = LoginItemState(control: control)

            state.setOpensAtLogin(true)

            #expect(state.status == .requiresApproval)
            #expect(!state.opensAtLogin)
        }

        @Test func turningOffAnItemThatIsNotRegisteredDoesNothing() {
            let control = FakeControl(status: .disabled)
            let state = LoginItemState(control: control)

            state.setOpensAtLogin(false)

            #expect(control.unregisters == 0)
        }

        @Test func aChangeMadeInSystemSettingsIsPickedUp() {
            let control = FakeControl(status: .enabled)
            let state = LoginItemState(control: control)

            control.status = .disabled
            state.refresh()

            #expect(!state.opensAtLogin)
        }

        @Test func theDockIconHidesOnlyWithNoWindowInMenuBarOnlyMode() {
            #expect(DockIcon.policy(hidesDockIcon: true, hasWindow: false) == .accessory)
            #expect(DockIcon.policy(hidesDockIcon: true, hasWindow: true) == .regular)
            #expect(DockIcon.policy(hidesDockIcon: false, hasWindow: false) == .regular)
        }
    }
#endif
