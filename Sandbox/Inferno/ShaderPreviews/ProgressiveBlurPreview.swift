//
//  ProgressiveBlurPreview.swift
//  Inferno
//
//  Created by Dale Price on 11/28/23.
//

import SwiftUI

/// A SwiftUI view that renders a gradient blur using the `VariableGaussianBlur` Metal shader.
struct ProgressiveBlurPreview: View {
    /// A binding to the opacity set in the parent view.
    @Binding var opacity: Double
    
    /// The start position of the variable blur, from 0 (top) to 1 (bottom).
    @State private var start = 0.0
    
    /// The start position of the variable blur, from 0 (top) to 1 (bottom).
    @State private var end = 1.0
    
    /// The blur radius.
    @State private var radius = 10.0
    
    /// The maximum number of samples to use for the blur.
    @State private var maxSamples = 15.0
    
    var body: some View {
        VStack {
            ContentPreviewSelector()
            
            ContentPreview()
                .variableBlur(radius: radius, maxSampleCount: Int(maxSamples)) { geometryProxy, context in
                    // Draw a rectangle covering the entire mask and fill it using a linear gradient from the specified points within the view's frame.
                    context.fill(
                        Path(geometryProxy.frame(in: .local)),
                        with: .linearGradient(
                            .init(colors: [.white, .clear]),
                            startPoint: .init(x: 0, y: geometryProxy.size.height * start),
                            endPoint: .init(x: 0, y: geometryProxy.size.height * end)
                        )
                    )
                }
            // We need to give the view an ID based on the parameters used within the drawing callback so that SwiftUI will call it again when they change.
                .id(start)
                .id(end)
                .opacity(opacity)
            
            GroupBox {
                LabeledContent("Blur Radius") {
                    Slider(value: $radius, in: 0.0...100.0)
                }
                LabeledContent("Blur Mask Start") {
                    Slider(value: $start, in: 0.0...1.0)
                }
                LabeledContent("Blur Mask End") {
                    Slider(value: $end, in: 0.0...1.0)
                }
                LabeledContent("Maximum Sample Count") {
                    Slider(value: $maxSamples, in: 1.0...30.0, step: 1.0)
                }
            }
            .scenePadding()
            .frame(maxWidth: 500)
        }
    }
}

#Preview {
    ProgressiveBlurPreview(opacity: .constant(1))
}
