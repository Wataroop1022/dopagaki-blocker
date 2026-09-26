import Foundation
import FamilyControls

enum AppGroup {
    static let id = "group.com.wataru.dopagaki"
    static var defaults: UserDefaults { UserDefaults(suiteName: id) ?? .standard }
}

enum SelectionStore {
    private static let key = "familyActivitySelection"

    static func save(_ selection: FamilyActivitySelection) {
        guard let data = try? JSONEncoder().encode(selection) else { return }
        AppGroup.defaults.set(data, forKey: key)
    }

    static func load() -> FamilyActivitySelection {
        guard let data = AppGroup.defaults.data(forKey: key),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return FamilyActivitySelection() }
        return selection
    }
}
