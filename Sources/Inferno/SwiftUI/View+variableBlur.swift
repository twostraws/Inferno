//
//  View+variableBlur.swift
//  Inferno
//
//  Created by Dale Price on 11/28/23.
//

import SwiftUI

@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
public extension View {
	
	/// Applies a variable blur to the view, with the blur radius at each pixel determined by a mask image.
	///
	/// - Parameters:
	///   - radius: The radial size of the blur in areas where the mask is fully opaque.
	///   - maxSampleCount: The maximum number of samples the shader may take from the view's layer in each direction. Higher numbers produce a smoother, higher quality blur but are more GPU intensive. Values larger than `radius` have no effect. The default of 15 provides balanced results but may cause banding on some images at larger blur radii.
	///   - verticalPassFirst: Whether or not to perform the vertical blur pass before the horizontal one. Changing this parameter may reduce smearing artifacts. Defaults to `false`, i.e. perform the horizontal pass first.
	///   - mask: An `Image` to use as the mask for the blur strength.
	/// - Returns: The view with the variable blur effect applied.
	func variableBlur(
		radius: CGFloat,
		maxSampleCount: Int = 15,
		verticalPassFirst: Bool = false,
		mask: Image
	) -> some View {
		self.visualEffect { content, _ in
			content.variableBlur(
				radius: radius,
				maxSampleCount: maxSampleCount,
				verticalPassFirst: verticalPassFirst,
				mask: mask
			)
		}
	}
	
	/// Applies a variable blur to the view, with the blur radius at each pixel determined by a mask that you create.
	///
	/// - Parameters:
	///   - radius: The radial size of the blur in areas where the mask is fully opaque.
	///   - maxSampleCount: The maximum number of samples the shader may take from the view's layer in each direction. Higher numbers produce a smoother, higher quality blur but are more GPU intensive. Values larger than `radius` have no effect. The default of 15 provides balanced results but may cause banding on some images at larger blur radii.
	///   - verticalPassFirst: Whether or not to perform the vertical blur pass before the horizontal one. Changing this parameter may reduce smearing artifacts. Defaults to `false`, i.e. perform the horizontal pass first.
	///   - maskRenderer: A rendering closure to draw the mask used to determine the intensity of the blur at each pixel. The closure receives a `GeometryProxy` with the view's layout information, and a `GraphicsContext` to draw into.
	/// - Returns: The view with the variable blur effect applied.
	///
	/// The strength of the blur effect at any point on the view is determined by the transparency of the mask at that point. Areas where the mask is fully opaque are blurred by the full radius; areas where the mask is partially transparent are blurred by a proportionally smaller radius. Areas where the mask is fully transparent are left unblurred.
	///
	/// - Tip: To achieve a progressive blur or gradient blur, draw a gradient from transparent to opaque in your mask image where you want the transition from clear to blurred to take place.
	///
	/// - Note: Because the blur is split into horizontal and vertical passes for performance, certain mask images over certain patterns may cause "smearing" artifacts along one axis. Changing the `verticalPassFirst` parameter may reduce this, but may cause smearing in the other direction.. To avoid smearing entirely, avoid drawing hard edges in your `maskRenderer`.
	///
	/// - Important: Because this effect is implemented as a SwiftUI `layerEffect`, it is subject to the same limitations. Namely, views backed by AppKit or UIKit views may not render. Instead, they log a warning and display a placeholder image to highlight the error.
	func variableBlur(
		radius: CGFloat,
		maxSampleCount: Int = 15,
		verticalPassFirst: Bool = false,
		maskRenderer: @escaping (GeometryProxy, inout GraphicsContext) -> Void
	) -> some View {
		self.visualEffect { content, geometryProxy in
			content.variableBlur(
				radius: radius,
				maxSampleCount: maxSampleCount,
				verticalPassFirst: verticalPassFirst,
				mask: Image(size: geometryProxy.size, renderer: { context in
					maskRenderer(geometryProxy, &context)
				})
			)
		}
	}
}
