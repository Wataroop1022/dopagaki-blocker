import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        makeConfiguration()
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        makeConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        makeConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        makeConfiguration()
    }

    private func makeConfiguration() -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: nil,
            icon: UIImage(systemName: "hand.raised.fill"),
            title: .init(text: "本当に開く?", color: .label),
            subtitle: .init(text: "なんとなく開こうとしていませんか。一呼吸おいてから決めましょう。", color: .secondaryLabel),
            primaryButtonLabel: .init(text: "それでも開く", color: .white),
            primaryButtonBackgroundColor: .systemRed,
            secondaryButtonLabel: .init(text: "やめておく", color: .systemBlue)
        )
    }
}
