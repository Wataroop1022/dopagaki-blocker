import Foundation
import FamilyControls

@MainActor
final class AppModel: ObservableObject {
    @Published var selection: FamilyActivitySelection {
        didSet {
            SelectionStore.save(selection)
            ShieldController.apply(selection)
        }
    }
    @Published private(set) var isAuthorized: Bool
    @Published private(set) var authorizationError: String?

    init() {
        selection = SelectionStore.load()
        isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
    }

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
            authorizationError = nil
        } catch {
            isAuthorized = false
            authorizationError = error.localizedDescription
        }
    }
}
