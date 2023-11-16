//
// GenerativePreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// A trivial SwiftUI view that renders a Metal shader into a whole
/// rectangle space, so it has complete control over rendering.
struct GenerativePreview: View {
    /// The initial time this view was created, so we can send
    /// elapsed time to the shader.
    @State private var start = Date.now

    /// The opacity of our preview view, so users can check how fading works.
    @State private var opacity = 1.0

    /// The shader we're rendering.
    var shader: GenerativeShader

    var body: some View {
        VStack {
            ContentPreviewSelector()

            TimelineView(.animation) { tl in
                let time = start.distance(to: tl.date)

                ContentPreview()
                    .opacity(opacity)
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            shader.createShader(elapsedTime: time, size: proxy.size)
                        )
                    }
            }
        }
        .toolbar {
            ToggleAlphaButton(opacity: $opacity)
        }
        .navigationSubtitle(shader.name)
    }
}

#Preview {
    TransitionPreview(shader: .example)
}

