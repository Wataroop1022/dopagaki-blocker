import DeviceActivity

final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        if activity == TemporaryUnlock.activityName {
            ShieldController.apply(SelectionStore.load())
        }
    }
}
