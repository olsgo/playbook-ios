import Playbook
import SwiftUI

#if os(iOS)
@available(iOS 15.0, *)
#elseif os(macOS)
@available(macOS 12.0, *)
#endif
internal struct GalleryDetail: View {
    let data: SelectData

    @StateObject
    private var shareState = ShareState()

    var body: some View {
        ZStack {
            ScenarioContentView(
                scenario: data.scenario,
                additionalSafeAreaInsets: PlatformEdgeInsets(
                    top: 56,
                    left: .zero,
                    bottom: .zero,
                    right: .zero
                ),
                shareState: shareState
            )
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            GalleryDetailTopBar(title: data.scenario.title.rawValue) {
                shareState.shareSnapshot()
            }
        }
        .background {
            Color(.background)
                .ignoresSafeArea()
        }
    }
}
