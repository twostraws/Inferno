//
//  ShapeBlurPreview.swift
//  Inferno
//
//  Created by Dale Price on 11/28/23.
//

import SwiftUI

/// A SwiftUI view that renders a variable blur masked by a shape, using the `VariableGaussianBlur` Metal shader.
struct ShapeBlurPreview: View {
    /// A binding to the opacity set in the parent view.
    @Binding var opacity: Double
    
    /// The shape to use as a mask for the variable blur shader.
    var shape: any Shape
    
    /// The amount to inset the shape relative to the view's frame, from 0 (no inset) to 0.5 (the center of the view)
    @State private var shapeInset = 0.25
    
    /// The amount to fade the edges of the shape in the mask, defining how the variable blur effect fades in at the edges.
    @State private var shapeFade = 5.0
    
    /// The blur radius.
    @State private var radius = 20.0
    
    /// The maximum number of samples to use for the blur.
    @State private var maxSamples = 15.0
    
    /// Whether to invert the mask (blur within the shape or outside the shape).
    @State private var invertMask = true
    
    var body: some View {
        VStack {
            ContentPreviewSelector()
            
            ContentPreview()
                .variableBlur(radius: radius, maxSampleCount: Int(maxSamples)) { geometryProxy, context in
                    // Add a blur to the mask to fade the edges of the shape.
                    context.addFilter(
                        .blur(radius: shapeFade)
                    )
                    
                    // Mask off the shape centered on the view, inset by `shapeInset` relative to the view's frame according to the proxy.
                    let horizInset = geometryProxy.size.width * shapeInset
                    let vertInset = geometryProxy.size.height * shapeInset
                    context.clip(
                        to: shape.path(in: CGRect(
                            x: horizInset,
                            y: vertInset,
                            width: geometryProxy.size.width - horizInset * 2,
                            height: geometryProxy.size.height - horizInset * 2)
                        ), options: invertMask ? .inverse : []
                    )
                    
                    // Fill the area of the mask that isn't clipped.
                    context.fill(
                        Path(geometryProxy.frame(in: .local)),
                        with: .color(.white)
                    )
                }
                .opacity(opacity)
                // We need to give the view an ID based on the parameters used within the drawing callback so that SwiftUI will call it again when they change.
                .id(shapeInset)
                .id(shapeFade)
                .id(invertMask)
            
            GroupBox {
                LabeledContent("Blur Radius") {
                    Slider(value: $radius, in: 0.0...100.0)
                }
                LabeledContent("Mask Shape Inset") {
                    Slider(value: $shapeInset, in: 0.0...0.5)
                }
                LabeledContent("Mask Shape Blur") {
                    Slider(value: $shapeFade, in: 0.0...100.0)
                }
                Toggle("Invert Mask", isOn: $invertMask)
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
    ShapeBlurPreview(opacity: .constant(1), shape: Circle())
}
