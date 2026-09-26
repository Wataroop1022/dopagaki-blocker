import SwiftUI
import FamilyControls
import DeviceActivity

struct RootView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        if model.isAuthorized {
            TabView {
                TodayTab()
                    .tabItem { Label("今日", systemImage: "clock") }
                SettingsTab()
                    .tabItem { Label("設定", systemImage: "gearshape") }
            }
        } else {
            OnboardingView()
        }
    }
}

struct OnboardingView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 64))
            Text("SNSの開きすぎを防止")
                .font(.title.bold())
            Text("登録したSNSアプリを開こうとすると確認画面を表示し、利用時間を集計します。スクリーンタイムへのアクセス許可が必要です。")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("許可して始める") {
                Task { await model.requestAuthorization() }
            }
            .buttonStyle(.borderedProminent)
            if let error = model.authorizationError {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding(24)
    }
}

struct TodayTab: View {
    @EnvironmentObject private var model: AppModel

    private var filter: DeviceActivityFilter {
        DeviceActivityFilter(
            segment: .daily(during: Calendar.current.dateInterval(of: .day, for: .now) ?? DateInterval(start: .now, duration: 86_400)),
            users: .all,
            devices: .init([.iPhone]),
            applications: model.selection.applicationTokens,
            categories: model.selection.categoryTokens,
            webDomains: model.selection.webDomainTokens
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if model.selection.applicationTokens.isEmpty && model.selection.categoryTokens.isEmpty {
                    Text("設定タブでSNSアプリを登録してください")
                        .foregroundStyle(.secondary)
                } else {
                    DeviceActivityReport(.today, filter: filter)
                }
            }
            .navigationTitle("今日のSNS")
        }
    }
}

struct SettingsTab: View {
    @EnvironmentObject private var model: AppModel
    @State private var showingPicker = false

    var body: some View {
        NavigationStack {
            List {
                Section("遮断するSNSアプリ") {
                    Button("アプリを選ぶ") { showingPicker = true }
                    Text("選択中: アプリ \(model.selection.applicationTokens.count)件 / カテゴリ \(model.selection.categoryTokens.count)件")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .familyActivityPicker(isPresented: $showingPicker, selection: $model.selection)
        }
    }
}
