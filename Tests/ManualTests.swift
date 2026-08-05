import Foundation

@main
enum ManualTests {
    static func main() {
        reminderFiresAtThresholdAndResets()
        longIdleResetsWorkSession()
        pausedAndVisiblePetDoNotAdvance()
        moderateIdlePausesWithoutResetting()
        actionMessagesAreBilingual()
        print("Kukuda logic tests passed")
    }

    private static func reminderFiresAtThresholdAndResets() {
        var state = BreakSessionState(reminderSeconds: 10)
        precondition(!state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false))
        precondition(state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false))
        precondition(state.remainingSeconds == 10)
    }

    private static func longIdleResetsWorkSession() {
        var state = BreakSessionState(reminderSeconds: 30)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false)
        _ = state.tick(delta: 1, idleSeconds: 300, enabled: true, petIsVisible: false)
        precondition(state.remainingSeconds == 30)
    }

    private static func pausedAndVisiblePetDoNotAdvance() {
        var state = BreakSessionState(reminderSeconds: 30)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: false, petIsVisible: false)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: true)
        precondition(state.remainingSeconds == 30)
    }

    private static func moderateIdlePausesWithoutResetting() {
        var state = BreakSessionState(reminderSeconds: 30)
        _ = state.tick(delta: 5, idleSeconds: 0, enabled: true, petIsVisible: false)
        _ = state.tick(delta: 5, idleSeconds: 120, enabled: true, petIsVisible: false)
        precondition(state.remainingSeconds == 25)
    }

    private static func actionMessagesAreBilingual() {
        let messages = ReminderMessages.rest
            + ReminderMessages.play
            + ReminderMessages.jump
            + ReminderMessages.forage
            + ReminderMessages.combo
        precondition(messages.count >= 30)
        precondition(messages.allSatisfy { !$0.english.isEmpty && !$0.maori.isEmpty })
    }
}
