import AppKit
import CoreGraphics

@MainActor
final class ActivityMonitor {
    var onBreakDue: (() -> Void)?
    var onStatusChange: ((TimeInterval) -> Void)?
    var isPetVisible: () -> Bool = { false }

    private var timer: Timer?
    private var lastTick = ProcessInfo.processInfo.systemUptime
    private var session: BreakSessionState

    init(reminderMinutes: Int) {
        session = BreakSessionState(reminderSeconds: TimeInterval(reminderMinutes * 60))
    }

    func start() {
        guard timer == nil else { return }
        lastTick = ProcessInfo.processInfo.systemUptime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.tick()
            }
        }
        tick()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        session.reset()
        onStatusChange?(session.remainingSeconds)
    }

    func setReminder(minutes: Int) {
        session.reminderSeconds = TimeInterval(minutes * 60)
        reset()
    }

    private func tick() {
        let now = ProcessInfo.processInfo.systemUptime
        let delta = now - lastTick
        lastTick = now
        let anyInputEvent = CGEventType(rawValue: UInt32.max)!
        let idle = CGEventSource.secondsSinceLastEventType(
            .combinedSessionState,
            eventType: anyInputEvent
        )
        let due = session.tick(
            delta: delta,
            idleSeconds: idle,
            enabled: Settings.shared.timerEnabled,
            petIsVisible: isPetVisible()
        )
        onStatusChange?(session.remainingSeconds)
        if due { onBreakDue?() }
    }
}
