import Foundation

@MainActor
final class Settings {
    static let shared = Settings()

    private enum Key {
        static let timerEnabled = "timerEnabled"
        static let reminderMinutes = "reminderMinutes"
        static let hasLaunched = "hasLaunched"
        static let hasShownWelcome = "hasShownWelcome"
    }

    private let defaults = UserDefaults.standard

    private init() {
        if !defaults.bool(forKey: Key.hasLaunched) {
            defaults.set(true, forKey: Key.hasLaunched)
            defaults.set(true, forKey: Key.timerEnabled)
            defaults.set(30, forKey: Key.reminderMinutes)
        }
    }

    var timerEnabled: Bool {
        get { defaults.bool(forKey: Key.timerEnabled) }
        set { defaults.set(newValue, forKey: Key.timerEnabled) }
    }

    var reminderMinutes: Int {
        get { max(1, defaults.integer(forKey: Key.reminderMinutes)) }
        set { defaults.set(max(1, newValue), forKey: Key.reminderMinutes) }
    }

    var hasShownWelcome: Bool {
        get { defaults.bool(forKey: Key.hasShownWelcome) }
        set { defaults.set(newValue, forKey: Key.hasShownWelcome) }
    }
}
