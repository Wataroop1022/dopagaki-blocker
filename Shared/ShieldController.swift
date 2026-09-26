import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

enum ShieldController {
    private static let store = ManagedSettingsStore()

    static func apply(_ selection: FamilyActivitySelection) {
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
    }

    static func lift() {
        store.clearAllSettings()
    }
}

enum TemporaryUnlock {
    static let activityName = DeviceActivityName("temporaryUnlock")
    // DeviceActivitySchedule requires an interval of at least 15 minutes.
    static let minutes = 15

    static func start() {
        let calendar = Calendar.current
        let now = Date()
        let end = now.addingTimeInterval(TimeInterval(minutes * 60))
        let units: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let schedule = DeviceActivitySchedule(
            intervalStart: calendar.dateComponents(units, from: now),
            intervalEnd: calendar.dateComponents(units, from: end),
            repeats: false
        )
        ShieldController.lift()
        try? DeviceActivityCenter().startMonitoring(activityName, during: schedule)
    }
}
