import DeviceActivity
import ManagedSettings
import SwiftUI

@main
struct DopagakiReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        TodayScene { summary in
            TodayView(summary: summary)
        }
    }
}

struct AppUsage: Identifiable {
    let token: ApplicationToken
    let duration: TimeInterval
    var id: ApplicationToken { token }
}

struct TodaySummary {
    var total: TimeInterval
    var apps: [AppUsage]
}

struct TodayScene: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .today
    let content: (TodaySummary) -> TodayView

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> TodaySummary {
        var perApp: [ApplicationToken: TimeInterval] = [:]
        var total: TimeInterval = 0

        for await activity in data {
            for await segment in activity.activitySegments {
                for await category in segment.categories {
                    for await application in category.applications {
                        guard let token = application.application.token else { continue }
                        perApp[token, default: 0] += application.totalActivityDuration
                        total += application.totalActivityDuration
                    }
                }
            }
        }

        let apps = perApp
            .map { AppUsage(token: $0.key, duration: $0.value) }
            .sorted { $0.duration > $1.duration }
        return TodaySummary(total: total, apps: apps)
    }
}

struct TodayView: View {
    let summary: TodaySummary

    var body: some View {
        List {
            Section {
                HStack {
                    Text("SNS合計")
                    Spacer()
                    Text(DurationFormat.string(summary.total))
                        .font(.title2.bold())
                }
            }
            Section("アプリ別") {
                if summary.apps.isEmpty {
                    Text("今日はまだSNSを触っていません")
                        .foregroundStyle(.secondary)
                }
                ForEach(summary.apps) { app in
                    HStack {
                        Label(app.token)
                            .labelStyle(.titleAndIcon)
                        Spacer()
                        Text(DurationFormat.string(app.duration))
                            .monospacedDigit()
                    }
                }
            }
        }
    }
}
