#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Represents part of the component state.
public struct Scenario {
    /// A unique title of scenario that describes component and its state.
    public var title: ScenarioTitle

    /// Represents how the component should be laid out.
    public var layout: ScenarioLayout

    /// A file path where defined this scenario.
    public var file: StaticString

    /// A line number where defined this scenario in file.
    public var line: UInt

    /// A closure that make a new content with passed context.
    public var content: (ScenarioContext) -> PlatformViewController

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping (ScenarioContext) -> PlatformViewController
    ) {
        self.title = title
        self.layout = layout
        self.file = file
        self.line = line
        self.content = content
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping (ScenarioContext) -> PlatformView
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { context in
                PlatformViewHostingController(view: content(context))
            }
        )
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping () -> PlatformViewController
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { _ in content() }
        )
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping () -> PlatformView
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { _ in
                PlatformViewHostingController(view: content())
            }
        )
    }
}

private final class PlatformViewHostingController: PlatformViewController {
    private let _view: PlatformView

    init(view: PlatformView) {
        self._view = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
    override func loadView() {
        view = _view
    }
    #elseif os(macOS)
    override func loadView() {
        self.view = _view
    }
    #endif
}
