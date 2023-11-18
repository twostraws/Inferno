//
// ContentPreviewSelector.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// A simple UI to select between the various preview types.
struct ContentPreviewSelector: View {
    @AppStorage("currentPreviewType") private var currentPreviewType = PreviewType.symbol
    
    var body: some View {
        #if !os(visionOS)
        Picker("Preview using:", selection: $currentPreviewType) {
            Text("Emoji").tag(PreviewType.emoji)
            Text("Image").tag(PreviewType.image)
            Text("Shape").tag(PreviewType.shape)
            Text("Symbol").tag(PreviewType.symbol)
        }
        .frame(maxWidth: 400)
        .pickerStyle(.segmented)
        .padding()
        #else
        HStack {
            Button(action: { currentPreviewType = .emoji }) {
                Text("Emoji")
            }
            Button(action: { currentPreviewType = .image }) {
                Text("Image")
            }
            Button(action: { currentPreviewType = .shape }) {
                Text("Shape")
            }
            Button(action: { currentPreviewType = .symbol }) {
                Text("Symbol")
            }
        }
        .frame(maxWidth: 400)
        .padding()
        #endif
    }
}

#Preview {
    ContentPreview()
}
