import Playbook
import SwiftUI

#if os(iOS)
@available(iOS 14.0, *)
internal struct ScenarioContentView: UIViewControllerRepresentable {
    let scenario: Scenario
    let additionalSafeAreaInsets: UIEdgeInsets
    let shareState: ShareState

    func makeUIViewController(context: Context) -> ScenarioViewController {
        let context = ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: false,
            screenSize: UIScreen.main.bounds.size
        )
        return ScenarioViewController(context: context)
    }

    func updateUIViewController(_ uiViewController: ScenarioViewController, context: Context) {
        shareState.scenarioViewController = uiViewController
        uiViewController.scenario = scenario
        uiViewController.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
#elseif os(macOS)
@available(macOS 11.0, *)
internal struct ScenarioContentView: NSViewControllerRepresentable {
    let scenario: Scenario
    let additionalSafeAreaInsets: NSEdgeInsets
    let shareState: ShareState

    func makeNSViewController(context: Context) -> ScenarioViewController {
        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
        let context = ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: false,
            screenSize: screenSize
        )
        return ScenarioViewController(context: context)
    }

    func updateNSViewController(_ nsViewController: ScenarioViewController, context: Context) {
        shareState.scenarioViewController = nsViewController
        nsViewController.scenario = scenario
        // Note: NSViewController doesn't have additionalSafeAreaInsets
        // This is typically handled differently on macOS
    }
}
#endif
