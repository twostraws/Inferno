//
// TimeTransformationPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// Renders a shader that requires a `TimelineView` to animate itself.
struct TimeTransformationPreview: View {
    /// The initial time this view was created, so we can send
    /// elapsed time to the shader.
    @State private var startTime = Date.now

    /// The opacity of our preview view, so users can check how fading works.
    @State private var opacity = 1.0

    /// The shader we're rendering.
    var shader: TimeTransformationShader

    var body: some View {
        VStack {
            ContentPreviewSelector()

            TimelineView(.animation) { timeline in
                let elapsed = startTime.distance(to: timeline.date)

                switch shader.type {
                case .colorEffect:
                    ContentPreview()
                        .opacity(opacity)
                        .colorEffect(
                            shader.createShader(elapsedTime: elapsed)
                        )

                case .distortionEffect:
                    ContentPreview()
                        .opacity(opacity)
                        .font(.system(size: 300))
                        .foregroundStyle(.white)
                        .distortionEffect(
                            shader.createShader(elapsedTime: elapsed),
                            maxSampleOffset: .zero
                        )

                case .visualEffectColor:
                    ContentPreview()
                        .opacity(opacity)
                        .visualEffect { content, proxy in
                            content
                                .colorEffect(
                                    shader.createShader(elapsedTime: elapsed, size: proxy.size)
                                )
                        }

                case .visualEffectDistortion:
                    ContentPreview()
                        .opacity(opacity)
                        .visualEffect { content, proxy in
                            content
                                .distortionEffect(
                                    shader.createShader(elapsedTime: elapsed, size: proxy.size),
                                    maxSampleOffset: .zero
                                )
                        }
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
    TimeTransformationPreview(shader: .example)
}
