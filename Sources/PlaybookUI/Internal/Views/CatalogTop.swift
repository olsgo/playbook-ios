import Playbook
import SwiftUI

#if os(iOS)
@available(iOS 15.0, *)
#elseif os(macOS)
@available(macOS 12.0, *)
#endif
internal struct CatalogTop: View {
    @EnvironmentObject
    private var catalogState: CatalogState
    @EnvironmentObject
    private var shareState: ShareState

    var body: some View {
        Group {
            if let selected = catalogState.selected {
                ScenarioContentView(
                    scenario: selected.scenario,
                    additionalSafeAreaInsets: PlatformEdgeInsets(
                        top: .zero,
                        left: .zero,
                        bottom: 56,
                        right: .zero
                    ),
                    shareState: shareState
                )
            }
            else {
                UnavailableView(
                    symbol: .docTextMagnifyingglass,
                    description: "No Scenarios found"
                )
            }
        }
        .frame(maxHeight: .infinity)
        .background {
            Color(.background)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
