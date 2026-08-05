import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let settings = Settings.shared
    private let pet = PetWindowController()
    private lazy var monitor = ActivityMonitor(reminderMinutes: settings.reminderMinutes)
    private var statusItem: NSStatusItem?
    private var statusMenuItem: NSMenuItem!
    private var toggleTimerItem: NSMenuItem!
    private var loginItem: NSMenuItem!
    private var intervalItems: [NSMenuItem] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        configureStatusItem()
        pet.onDismiss = { [weak self] in self?.monitor.reset() }
        monitor.isPetVisible = { [weak pet] in pet?.isVisible ?? false }
        monitor.onBreakDue = { [weak self] in self?.pet.show() }
        monitor.onStatusChange = { [weak self] remaining in
            self?.updateStatus(remaining: remaining)
        }
        monitor.start()

        // A menu-bar-only app can otherwise look like it did nothing when
        // launched from Finder. Let Kiwi introduce itself the first time.
        if !settings.hasShownWelcome {
            settings.hasShownWelcome = true
            pet.show()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        monitor.stop()
    }

    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows flag: Bool
    ) -> Bool {
        ensureStatusItemVisible()
        pet.show()
        return true
    }

    private func configureStatusItem() {
        if let statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
        }

        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem = item
        item.isVisible = true

        if let button = item.button {
            button.title = "--:--"
            button.toolTip = "Kukuda · Kia whakatā"
            button.font = .systemFont(ofSize: 13, weight: .semibold)
            button.imagePosition = .imageLeading
            button.imageScaling = .scaleProportionallyDown
            button.setAccessibilityLabel("Kukuda break timer")

            if let iconURL = Bundle.main.url(forResource: "Kukuda", withExtension: "icns"),
               let icon = NSImage(contentsOf: iconURL) {
                icon.size = NSSize(width: 18, height: 18)
                button.image = icon
            }
        }

        let menu = NSMenu()
        let title = NSMenuItem(title: "Kukuda · Kia whakatā", action: nil, keyEquivalent: "")
        title.isEnabled = false
        menu.addItem(title)

        statusMenuItem = NSMenuItem(title: "Preparing timer…", action: nil, keyEquivalent: "")
        statusMenuItem.isEnabled = false
        menu.addItem(statusMenuItem)
        menu.addItem(.separator())

        let showItem = NSMenuItem(title: "Show Kukuda Now · Karangatia a Kukuda", action: #selector(showNow), keyEquivalent: "k")
        showItem.target = self
        menu.addItem(showItem)
        toggleTimerItem = NSMenuItem(title: "", action: #selector(toggleTimer), keyEquivalent: "p")
        toggleTimerItem.target = self
        menu.addItem(toggleTimerItem)
        let resetItem = NSMenuItem(title: "Reset Work Session · Tīmata anō", action: #selector(resetSession), keyEquivalent: "r")
        resetItem.target = self
        menu.addItem(resetItem)

        let intervalParent = NSMenuItem(title: "Reminder Interval · Wā whakamaumahara", action: nil, keyEquivalent: "")
        let intervalMenu = NSMenu()
        for minutes in [1, 15, 30, 45, 60] {
            let item = NSMenuItem(title: "\(minutes) minutes", action: #selector(selectInterval(_:)), keyEquivalent: "")
            item.tag = minutes
            item.target = self
            intervalMenu.addItem(item)
            intervalItems.append(item)
        }
        intervalParent.submenu = intervalMenu
        menu.addItem(intervalParent)

        menu.addItem(.separator())
        loginItem = NSMenuItem(title: "Start at Login · Tīmata aunoa", action: #selector(toggleLoginItem), keyEquivalent: "")
        loginItem.target = self
        menu.addItem(loginItem)
        menu.addItem(.separator())
        let quitItem = NSMenuItem(title: "Quit Kukuda · Kāti", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        item.menu = menu
        ensureStatusItemVisible()
        refreshMenuChecks()
    }

    private func ensureStatusItemVisible() {
        guard let statusItem else {
            configureStatusItem()
            return
        }
        statusItem.length = NSStatusItem.variableLength
        statusItem.isVisible = true
        statusItem.button?.isHidden = false
    }

    private func updateStatus(remaining: TimeInterval) {
        let totalSeconds = max(0, Int(ceil(remaining)))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let countdown = String(format: "%02d:%02d", minutes, seconds)
        if settings.timerEnabled {
            if pet.isVisible {
                statusItem?.button?.title = "休息"
                statusMenuItem.title = "Break time · He wā whakatā"
            } else {
                statusItem?.button?.title = countdown
                statusMenuItem.title = "Remaining \(countdown) · E \(countdown) e toe ana"
            }
            toggleTimerItem.title = "Pause Timer · Whakatārewatia"
        } else {
            statusItem?.button?.title = "暂停"
            statusMenuItem.title = "Timer paused · Kua whakatārewatia"
            toggleTimerItem.title = "Start Timer · Tīmata te wā"
        }
        refreshMenuChecks()
    }

    private func refreshMenuChecks() {
        intervalItems.forEach { $0.state = $0.tag == settings.reminderMinutes ? .on : .off }
        loginItem?.state = LoginItemManager.isEnabled ? .on : .off
    }

    @objc private func showNow() {
        pet.show()
        updateStatus(remaining: TimeInterval(settings.reminderMinutes * 60))
    }

    @objc private func toggleTimer() {
        settings.timerEnabled.toggle()
        if !settings.timerEnabled { pet.dismiss() }
        monitor.reset()
    }

    @objc private func resetSession() {
        monitor.reset()
    }

    @objc private func selectInterval(_ sender: NSMenuItem) {
        settings.reminderMinutes = sender.tag
        monitor.setReminder(minutes: sender.tag)
        refreshMenuChecks()
    }

    @objc private func toggleLoginItem() {
        do {
            try LoginItemManager.setEnabled(!LoginItemManager.isEnabled)
            refreshMenuChecks()
        } catch {
            let alert = NSAlert()
            alert.messageText = "Couldn’t change the login setting"
            alert.informativeText = "You can still open Kukuda manually. \(error.localizedDescription)"
            alert.alertStyle = .warning
            alert.runModal()
        }
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
