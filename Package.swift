// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Playbook",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(name: "Playbook", targets: ["Playbook"]),
        .library(name: "PlaybookSnapshot", targets: ["PlaybookSnapshot"]),
        .library(name: "PlaybookUI", targets: ["PlaybookUI"]),
    ],
    targets: [
        .target(
            name: "Playbook"
        ),
        .target(
            name: "PlaybookSnapshot",
            dependencies: ["Playbook"],
            // Snapshot support is iOS-only due to device simulation requirements
            // (UITraitCollection, safe area variants, device-specific configurations)
            exclude: []
        ),
        .target(
            name: "PlaybookUI",
            dependencies: ["Playbook"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
