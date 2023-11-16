//
// SimpleTransformationPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// Renders a simple shader, optionally provide a replacement color
/// and also a customizable input value.
struct SimpleTransformationPreview: View {
    /// The replacement color to send to the shader.
    @State private var newColor = Color.red

    /// The input value to control shader strength or similar.
    @State private var sliderValue = 1.0

    /// The opacity of our preview view, so users can check how fading works.
    @State private var opacity = 1.0

    /// The shader we're rendering.
    var shader: SimpleTransformationShader

    var body: some View {
        VStack {
            ContentPreviewSelector()

            if shader.type == .colorEffect {
                ContentPreview()
                    .opacity(opacity)
                    .colorEffect(
                        shader.createShader(color: newColor, value: sliderValue)
                    )
            } else {
                ContentPreview()
                    .opacity(opacity)
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            shader.createShader(color: newColor, value: sliderValue, size: proxy.size), maxSampleOffset: .zero)
                    }
            }

            ColorPicker("Replacement Color", selection: $newColor)
                .opacity(shader.usesReplacementColor ? 1 : 0)

            LabeledContent("Value: ") {
                Slider(value: $sliderValue, in: shader.valueRange ?? 0...1)
            }
            .frame(maxWidth: 500)
            .opacity(shader.valueRange != nil ? 1 : 0)
            .onAppear {
                // If we have a value range for this shader,
                // assume a default value of the middle of
                // that range.
                if let valueRange = shader.valueRange {
                    sliderValue = (valueRange.upperBound - valueRange.lowerBound) / 2
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
    SimpleTransformationPreview(shader: .example)
}
