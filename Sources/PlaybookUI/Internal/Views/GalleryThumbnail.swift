import Playbook
import SwiftUI

#if os(iOS)
@available(iOS 15.0, *)
#elseif os(macOS)
@available(macOS 12.0, *)
#endif
internal struct GalleryThumbnail: View {
    let data: SearchedData

    @State
    private var image: PlatformImage?
    @EnvironmentObject
    private var imageLoader: ImageLoader
    @Environment(\.colorScheme)
    private var colorScheme
    private let contentScale: CGFloat = 0.3
    private let imageScale: CGFloat = 0.5
    #if os(iOS)
    private let screenSize = UIScreen.main.fixedCoordinateSpace.bounds.size
    #elseif os(macOS)
    private let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    #endif
    private let cornerRadius: CGFloat = 16

    var body: some View {
        thumbnailContent
            .frame(width: contentWidth, height: contentHeight, alignment: .top)
            .overlay(alignment: .bottom) {
                NameLabel(data: data)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(strokeColor, lineWidth: 4)
            }
            .cornerRadius(cornerRadius)
            .padding(4)
            .onChange(of: colorScheme) { _ in
                image = nil
            }
            .task(id: colorScheme, priority: .background) {
                let source = ImageSource(
                    scenario: data.scenario,
                    category: data.category,
                    size: screenSize,
                    scale: imageScale,
                    colorScheme: colorScheme
                )
                image = await imageLoader.loadImage(for: source)
            }
    }

    @ViewBuilder
    private var thumbnailContent: some View {
        ZStack {
            Color.playbookBackground

            if let image {
                imageView(for: image)
            }
            else {
                Placeholder()
            }
        }
    }

    @ViewBuilder
    private func imageView(for image: PlatformImage) -> some View {
        let imageWidth = image.size.width * contentScale / imageScale
        let imageHeight = image.size.height * contentScale / imageScale

        #if os(iOS)
        Image(uiImage: image)
            .resizable()
            .frame(width: imageWidth, height: imageHeight)
        #elseif os(macOS)
        Image(nsImage: image)
            .resizable()
            .frame(width: imageWidth, height: imageHeight)
        #endif
    }
}

@available(iOS 15, *)
private struct NameLabel: View {
    let data: SearchedData

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .ignoresSafeArea()

            HighlightText(
                content: data.scenario.title.rawValue,
                range: data.highlightRange
            )
            .textStyle(font: .caption)
            .minimumScaleFactor(0.1)
            .padding(.top, 4)
            .padding([.bottom, .horizontal], 8)
            .frame(maxWidth: .infinity)
        }
        .background {
            MaterialView()
        }
    }
}

private struct Placeholder: View {
    @State
    private var isAnimating = false

    var body: some View {
        Color(.translucentFill)
            .opacity(isAnimating ? 1 : 0)
            .animation(
                .linear(duration: 0.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                if !isAnimating {
                    isAnimating = true
                }
            }
    }
}

#if os(iOS)
@available(iOS 15.0, *)
#elseif os(macOS)
@available(macOS 12.0, *)
#endif
private extension GalleryThumbnail {
    var contentWidth: CGFloat {
        screenSize.width * contentScale
    }

    var contentHeight: CGFloat {
        screenSize.height * contentScale
    }

    var strokeColor: Color {
        #if os(iOS)
        Color(.systemGray5)
        #elseif os(macOS)
        Color(nsColor: .separatorColor)
        #endif
    }
}
