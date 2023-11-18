//
// AbsoluteTouchTransformationPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// A view that sends drag gesture data to a shader based on the absolute
/// position of a touch.
struct AbsoluteTouchTransformationPreview: View {
    /// The current touch location.
    @State private var touch = CGPoint.zero

    /// The opacity of our preview view, so users can check how fading works.
    @Binding var opacity: Double

    /// The input value to control shader strength or similar.
    @Binding var value: Double

    /// The shader we're rendering.
    var shader: TouchTransformationShader

    var body: some View {
        VStack {
            ContentPreviewSelector()
            ContentPreview()
                .opacity(opacity)
                .visualEffect { content, proxy in
                    content
                        .layerEffect(
                            shader.createShader(size: proxy.size, touchLocation: touch, value: value),
                            maxSampleOffset: .zero
                        )
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { touch = $0.location }
                )
        }
    }
}
