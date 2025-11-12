#if os(iOS)
import UIKit

public typealias PlatformView = UIView
public typealias PlatformViewController = UIViewController
public typealias PlatformColor = UIColor
public typealias PlatformImage = UIImage
public typealias PlatformWindow = UIWindow
public typealias PlatformScreen = UIScreen
public typealias PlatformLayoutPriority = UILayoutPriority
public typealias PlatformEdgeInsets = UIEdgeInsets

#elseif os(macOS)
import AppKit

public typealias PlatformView = NSView
public typealias PlatformViewController = NSViewController
public typealias PlatformColor = NSColor
public typealias PlatformImage = NSImage
public typealias PlatformWindow = NSWindow
public typealias PlatformScreen = NSScreen
public typealias PlatformLayoutPriority = NSLayoutConstraint.Priority
public typealias PlatformEdgeInsets = NSEdgeInsets

#endif

// Common extensions for platform-agnostic code
extension PlatformColor {
    static var playbookClearBackground: PlatformColor {
        return .clear
    }
}

#if os(macOS)
extension NSEdgeInsets {
    static var zero: NSEdgeInsets {
        NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
#endif
