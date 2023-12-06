//
//  VisualEffect+variableBlur.swift
//  Inferno
//
//  Created by Dale Price on 11/28/23.
//

import SwiftUI

@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
public extension VisualEffect {
    
    /// Applies a variable blur, with the blur radius at each pixel determined by a mask image.
    ///
    /// - Tip: To automatically generate a mask image of the same size as the view, use ``SwiftUI/View/variableBlur(radius:maxSampleCount:verticalPassFirst:maskRenderer:)`` which creates the image from drawing instructions you provide to a `GraphicsContext`.
    ///
    /// - Parameters:
    ///   - radius: The maximum radial size of the blur in areas where the mask is fully opaque.
    ///   - maxSampleCount: The maximum number of samples to take from the view's layer in each direction. Higher numbers produce a smoother, higher quality blur but are more GPU intensive. Values larger than `radius` have no effect.
    ///   - verticalPassFirst: Whether or not to perform the vertical blur pass before the horizontal one. Changing this parameter may reduce smearing artifacts. Defaults to `false`, i.e. perform the horizontal pass first.
    ///   - mask: An image with an alpha channel to use as mask to determine the strength of the blur effect at each pixel. Fully transparent areas are unblurred; fully opaque areas are blurred by the full radius; partially transparent areas are blurred by the radius multiplied by the alpha value. The mask will be uv-mapped to cover the entire view.
    ///   - isEnabled: Whether the effect is enabled or not.
    /// - Returns: A new view that renders `self` with the blur shader applied as a layer effect.
    ///
    /// - Important: Because this effect is based on SwiftUI's `layerEffect`, views backed by AppKit or UIKit views may not render. Instead, they log a warning and display a placeholder image to highlight the error.
    func variableBlur(
        radius: CGFloat,
        maxSampleCount: Int = 15,
        verticalPassFirst: Bool = false,
        mask: Image,
        isEnabled: Bool = true
    ) -> some VisualEffect {
        self.layerEffect(
            InfernoShaderLibrary.variableBlur(
                .boundingRect,
                .float(radius),
                .float(CGFloat(maxSampleCount)),
                .image(mask),
                .float(verticalPassFirst ? 1 : 0)
            ),
            maxSampleOffset: CGSize(width: radius , height: radius),
            isEnabled: isEnabled
        )
        .layerEffect(
            InfernoShaderLibrary.variableBlur(
                .boundingRect,
                .float(radius),
                .float(CGFloat(maxSampleCount)),
                .image(mask),
                .float(verticalPassFirst ? 0 : 1)
            ),
            maxSampleOffset: CGSize(width: radius, height: radius),
            isEnabled: isEnabled
        )
    }
}
