//
// RelativeTouchTransformationPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// A view that sends drag gesture data to a shader based on the relative
/// position of a touch – how much the user dragged since the last movement.
struct RelativeTouchTransformationPreview: View {
    /// The current touch location.
    @State private var touch = CGSize.zero

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
                .drawingGroup()
                .layerEffect(
                    shader.createShader(touchLocation: CGPoint(x: touch.width, y: touch.height), value: value),
                    maxSampleOffset: .zero
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { touch = $0.translation }
                )
        }
    }
}
