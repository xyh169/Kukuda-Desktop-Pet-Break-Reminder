import AppKit

@MainActor
final class PetWindowController: NSWindowController {
    var onDismiss: (() -> Void)?
    private let petView = KiwiPetView(frame: NSRect(x: 0, y: 0, width: 360, height: 260))
    private var animationTimer: Timer?
    private var messageTimer: Timer?
    private var actionStartTime: TimeInterval = 0
    private var actionEndTime: TimeInterval = 0
    private var nextRandomAction = ProcessInfo.processInfo.systemUptime
    private var targetPoint: NSPoint?
    private var nextDirectionChange = ProcessInfo.processInfo.systemUptime
    private let normalSpeed: CGFloat = 1.15

    var isVisible: Bool { window?.isVisible == true }

    init() {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 260),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        panel.hidesOnDeactivate = false
        panel.isMovableByWindowBackground = false
        panel.contentView = petView
        super.init(window: panel)

        petView.onAction = { [weak self] action in
            guard let self else { return }
            switch action {
            case .play: self.play()
            case .dismiss: self.dismiss()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        guard !isVisible else {
            petView.message = ReminderMessages.randomRest(excluding: petView.message)
            return
        }
        let screen = screenUnderMouse() ?? NSScreen.main
        guard let screen else { return }
        let visible = screen.visibleFrame
        let startX = visible.minX - 250
        window?.setFrameOrigin(NSPoint(x: startX, y: visible.minY + 8))
        window?.orderFrontRegardless()
        petView.message = ReminderMessages.randomRest()
        petView.motion = .walking
        petView.actionProgress = 0
        targetPoint = nil
        chooseNewTarget(in: screen)
        scheduleRandomAction()
        beginAnimation()
        scheduleNextMessage()
    }

    func dismiss() {
        animationTimer?.invalidate()
        messageTimer?.invalidate()
        animationTimer = nil
        messageTimer = nil
        window?.orderOut(nil)
        onDismiss?()
    }

    private func play() {
        beginAction(.dancing, duration: 4.5, message: ReminderMessages.randomPlay())
        targetPoint = nil
        scheduleNextMessage()
    }

    private func beginAnimation() {
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.animateFrame()
            }
        }
    }

    private func animateFrame() {
        guard let window, let screen = screenForWindow() else { return }
        let bounds = screen.visibleFrame
        let now = ProcessInfo.processInfo.systemUptime
        updateAction(at: now)
        if targetPoint == nil || now >= nextDirectionChange {
            chooseNewTarget(in: screen)
        }

        if let targetPoint {
            let origin = window.frame.origin
            let dx = targetPoint.x - origin.x
            let dy = targetPoint.y - origin.y
            let distance = hypot(dx, dy)

            if distance < 5 {
                chooseNewTarget(in: screen)
            } else {
                let speed: CGFloat
                switch petView.motion {
                case .foraging: speed = 0
                case .jumping: speed = normalSpeed * 0.72
                case .dancing: speed = normalSpeed * 1.75
                case .walking: speed = normalSpeed
                }
                let next = NSPoint(
                    x: origin.x + dx / distance * speed,
                    y: origin.y + dy / distance * speed
                )
                let clamped = NSPoint(
                    x: min(max(next.x, bounds.minX), bounds.maxX - window.frame.width),
                    y: min(max(next.y, bounds.minY), bounds.maxY - window.frame.height)
                )
                window.setFrameOrigin(clamped)
                if abs(dx) > 1 { petView.facingRight = dx > 0 }
            }
        }
        switch petView.motion {
        case .walking: petView.animationPhase += 0.10
        case .jumping: petView.animationPhase += 0.14
        case .foraging: petView.animationPhase += 0.11
        case .dancing: petView.animationPhase += 0.16
        }
    }

    private func updateAction(at now: TimeInterval) {
        if petView.motion != .walking {
            let duration = max(0.1, actionEndTime - actionStartTime)
            petView.actionProgress = CGFloat(min(1, max(0, (now - actionStartTime) / duration)))
            if now >= actionEndTime {
                let completedMotion = petView.motion
                if completedMotion == .foraging && Int.random(in: 0..<100) < 45 {
                    let followUp: KiwiPetView.Motion = Bool.random() ? .jumping : .dancing
                    let followUpDuration: TimeInterval = followUp == .jumping ? 2.4 : 3.2
                    beginAction(followUp, duration: followUpDuration, message: ReminderMessages.randomCombo())
                    targetPoint = nil
                    return
                }
                petView.motion = .walking
                petView.actionProgress = 0
                targetPoint = nil
                scheduleRandomAction()
            }
            return
        }

        if now >= nextRandomAction {
            if Bool.random() {
                beginAction(.jumping, duration: 3.4, message: ReminderMessages.randomJump())
            } else {
                beginAction(.foraging, duration: 5.8, message: ReminderMessages.randomForage())
            }
        }
    }

    private func beginAction(
        _ motion: KiwiPetView.Motion,
        duration: TimeInterval,
        message: ReminderMessage
    ) {
        let now = ProcessInfo.processInfo.systemUptime
        petView.motion = motion
        petView.animationPhase = 0
        petView.actionProgress = 0
        petView.message = message
        actionStartTime = now
        actionEndTime = now + duration
    }

    private func scheduleRandomAction() {
        nextRandomAction = ProcessInfo.processInfo.systemUptime + TimeInterval.random(in: 4...10)
    }

    private func chooseNewTarget(in screen: NSScreen) {
        guard let window else { return }
        let bounds = screen.visibleFrame
        let maxX = max(bounds.minX, bounds.maxX - window.frame.width)
        let maxY = max(bounds.minY, bounds.maxY - window.frame.height)
        targetPoint = NSPoint(
            x: CGFloat.random(in: bounds.minX...maxX),
            y: CGFloat.random(in: bounds.minY...maxY)
        )
        nextDirectionChange = ProcessInfo.processInfo.systemUptime + TimeInterval.random(in: 7...15)
    }

    private func scheduleNextMessage() {
        messageTimer?.invalidate()
        let delay = TimeInterval.random(in: 10...17)
        messageTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self, self.isVisible else { return }
                if self.petView.motion == .walking {
                    self.petView.message = ReminderMessages.randomRest(excluding: self.petView.message)
                }
                self.scheduleNextMessage()
            }
        }
    }

    private func screenUnderMouse() -> NSScreen? {
        let location = NSEvent.mouseLocation
        return NSScreen.screens.first { $0.frame.contains(location) }
    }

    private func screenForWindow() -> NSScreen? {
        window?.screen ?? screenUnderMouse() ?? NSScreen.main
    }
}
