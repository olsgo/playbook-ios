import Playbook
import SwiftUI

@MainActor
internal final class ShareState: ObservableObject {
    weak var scenarioViewController: ScenarioViewController?

    func shareSnapshot() {
        guard let scenarioViewController else {
            return
        }

        #if os(iOS)
        shareSnapshot_iOS(scenarioViewController: scenarioViewController)
        #elseif os(macOS)
        shareSnapshot_macOS(scenarioViewController: scenarioViewController)
        #endif
    }

    #if os(iOS)
    private func shareSnapshot_iOS(scenarioViewController: ScenarioViewController) {
        let bounds = scenarioViewController.view.bounds
        let image = UIGraphicsImageRenderer(bounds: bounds).image { _ in
            scenarioViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        if !Bundle.main.hasPhotoLibraryAddUsageDescription {
            activityViewController.excludedActivityTypes = [.saveToCameraRoll]
        }

        activityViewController.popoverPresentationController?.sourceView = scenarioViewController.view
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        scenarioViewController.present(activityViewController, animated: true)
    }
    #endif

    #if os(macOS)
    private func shareSnapshot_macOS(scenarioViewController: ScenarioViewController) {
        guard let image = captureViewAsImage(scenarioViewController.view) else {
            return
        }

        let picker = NSSharingServicePicker(items: [image])

        // Position the picker at the center of the view
        let bounds = scenarioViewController.view.bounds
        let rect = CGRect(
            x: bounds.midX - 100,
            y: bounds.midY - 100,
            width: 200,
            height: 200
        )

        picker.show(relativeTo: rect, of: scenarioViewController.view, preferredEdge: .minY)
    }

    private func captureViewAsImage(_ view: NSView) -> NSImage? {
        let bounds = view.bounds
        guard bounds.width > 0, bounds.height > 0 else {
            return nil
        }

        // Create a bitmap representation
        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }

        view.cacheDisplay(in: bounds, to: bitmapRep)

        // Create an NSImage from the bitmap
        let image = NSImage(size: bounds.size)
        image.addRepresentation(bitmapRep)

        return image
    }
    #endif
}

private extension Bundle {
    var hasPhotoLibraryAddUsageDescription: Bool {
        let usage = object(forInfoDictionaryKey: "NSPhotoLibraryAddUsageDescription") as? String
        return usage.map { !$0.isEmpty } ?? false
    }
}
