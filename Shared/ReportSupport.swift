import Foundation
import DeviceActivity

extension DeviceActivityReport.Context {
    static let today = Self("Today")
}

enum DurationFormat {
    static func string(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = interval >= 3600 ? [.hour, .minute] : [.minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: interval) ?? "0s"
    }
}
