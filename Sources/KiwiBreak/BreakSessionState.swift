import Foundation

struct BreakSessionState {
    private(set) var activeSeconds: TimeInterval = 0
    var reminderSeconds: TimeInterval

    init(reminderSeconds: TimeInterval) {
        self.reminderSeconds = reminderSeconds
    }

    var remainingSeconds: TimeInterval {
        max(0, reminderSeconds - activeSeconds)
    }

    mutating func tick(
        delta: TimeInterval,
        idleSeconds: TimeInterval,
        enabled: Bool,
        petIsVisible: Bool
    ) -> Bool {
        guard enabled, !petIsVisible else { return false }

        if idleSeconds >= 300 {
            activeSeconds = 0
            return false
        }

        // A short pause does not erase progress, while actively using the Mac
        // advances the work session.
        if idleSeconds < 60 {
            activeSeconds += max(0, min(delta, 5))
        }

        if activeSeconds >= reminderSeconds {
            activeSeconds = 0
            return true
        }
        return false
    }

    mutating func reset() {
        activeSeconds = 0
    }
}
