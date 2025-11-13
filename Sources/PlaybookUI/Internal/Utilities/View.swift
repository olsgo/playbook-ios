import SwiftUI

#if os(iOS)
@available(iOS 15.0, *)
#elseif os(macOS)
@available(macOS 12.0, *)
#endif
internal extension View {
    func textStyle(
        font: Font,
        color: Color = {
            #if os(iOS)
            Color(.label)
            #elseif os(macOS)
            Color(nsColor: .labelColor)
            #endif
        }(),
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) -> some View {
        foregroundStyle(color)
            .font(font)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .dynamicTypeSize(.large)
    }

    func imageStyle(
        font: Font,
        color: Color = {
            #if os(iOS)
            Color(.label)
            #elseif os(macOS)
            Color(nsColor: .labelColor)
            #endif
        }()
    ) -> some View {
        foregroundStyle(color)
            .font(font)
            .dynamicTypeSize(.large)
    }
}

// Cross-platform Color helpers
internal extension Color {
    static var playbookBackground: Color {
        #if os(iOS)
        Color(uiColor: .background)
        #elseif os(macOS)
        Color(nsColor: .background)
        #endif
    }

    static var playbookHighlight: Color {
        #if os(iOS)
        Color(uiColor: .highlight)
        #elseif os(macOS)
        Color(nsColor: .highlight)
        #endif
    }

    static var playbookTranslucentFill: Color {
        #if os(iOS)
        Color(uiColor: .translucentFill)
        #elseif os(macOS)
        Color(nsColor: .translucentFill)
        #endif
    }

    static var playbookSecondaryLabel: Color {
        #if os(iOS)
        Color(.secondaryLabel)
        #elseif os(macOS)
        Color(nsColor: .secondaryLabelColor)
        #endif
    }
}
