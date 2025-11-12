import SwiftUI

#if os(iOS)
@available(iOS 15.0, *)
#elseif os(macOS)
@available(macOS 12.0, *)
#endif
internal struct SearchBar: View {
    @Binding
    var text: String
    @FocusState
    private var isFocused
    @State
    private var isEditing = false

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(symbol: .magnifyingglass)
                    .imageStyle(
                        font: .headline.weight(.regular),
                        color: Color.secondary
                    )
                    .padding(.trailing, 4)
                    .onTapGesture {
                        isFocused = true
                    }

                TextField(
                    text: $text,
                    prompt: Text("Search")
                        .foregroundColor(Color.secondary)
                ) {
                    EmptyView()
                }
                .textFieldStyle(.plain)
                .focused($isFocused)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(symbol: .xmarkCircleFill)
                            .foregroundStyle(.gray)
                            .dynamicTypeSize(.large)
                    }
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background {
                Rectangle()
                    .fill(Color(white: 0.95).opacity(0.5))
                    .clipShape(.capsule)
            }

            if isEditing {
                Spacer.fixed(length: 8)

                Button("Cancel") {
                    isFocused = false
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
                .transition(
                    .move(edge: .trailing)
                        .combined(with: .opacity)
                )
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .clipped()
        .dynamicTypeSize(.large)
        .animation(.easeOut(duration: 0.2), value: isEditing)
        .onChange(of: isFocused) { isFocused in
            isEditing = isFocused
        }
    }
}
