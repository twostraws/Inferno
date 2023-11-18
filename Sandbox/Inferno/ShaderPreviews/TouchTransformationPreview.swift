//
// TouchTransformationPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// An intermediate view that resolves to either absolute or relative
/// touch transformation previews, depending on the shader.
struct TouchTransformationPreview: View {
    /// The opacity of our preview view, so users can check how fading works.
    @State private var opacity = 1.0

    /// The input value to control shader strength or similar.
    @State private var sliderValue = 1.0

    /// The shader we're rendering.
    var shader: TouchTransformationShader

    var body: some View {
        VStack {
            if shader.usesSize {
                AbsoluteTouchTransformationPreview(opacity: $opacity, value: $sliderValue, shader: shader)
            } else {
                RelativeTouchTransformationPreview(opacity: $opacity, value: $sliderValue, shader: shader)
            }

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

            Text("Drag around on the image to try the shader.")
        }
        .toolbar {
            ToggleAlphaButton(opacity: $opacity)
        }
        .navigationSubtitle(shader.name)
    }
}
