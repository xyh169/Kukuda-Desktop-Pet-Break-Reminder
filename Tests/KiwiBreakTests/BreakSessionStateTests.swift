import Testing
@testable import KiwiBreak

struct BreakSessionStateTests {
    @Test func reminderFiresAtThresholdAndResets() {
        var state = BreakSessionState(reminderSeconds: 10)
        #expect(!state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false))
        #expect(state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false))
        #expect(state.remainingSeconds == 10)
    }

    @Test func longIdleResetsWorkSession() {
        var state = BreakSessionState(reminderSeconds: 30)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false)
        _ = state.tick(delta: 1, idleSeconds: 300, enabled: true, petIsVisible: false)
        #expect(state.remainingSeconds == 30)
    }

    @Test func pausedAndVisiblePetDoNotAdvance() {
        var state = BreakSessionState(reminderSeconds: 30)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: false, petIsVisible: false)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: true)
        #expect(state.remainingSeconds == 30)
    }

    @Test func moderateIdlePausesWithoutResetting() {
        var state = BreakSessionState(reminderSeconds: 30)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false)
        _ = state.tick(delta: 5, idleSeconds: 120, enabled: true, petIsVisible: false)
        #expect(state.remainingSeconds == 25)
    }
}
