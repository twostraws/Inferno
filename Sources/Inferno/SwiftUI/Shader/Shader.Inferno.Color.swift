//
// Shader.Inferno.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
public extension Shader.inferno {
	
	/// A namespace for all `colorEffect` shaders exported by Inferno
	enum color {}
}

@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
public extension Shader.inferno.color {
	/// A shader that generates a constantly cycling color gradient, centered
	/// on the input view.
	///
	/// - Parameters:
	///   - size: The size of the whole image, in user-space.
	///   - elapsedTime: The number of elapsed seconds since the shader was created
	static func animatedGradientFill(
		size: CGSize,
		elapsedTime: Double
	) -> Shader {
		InfernoShaderLibrary.animatedGradientFill(
			.float2(size),
			.float(elapsedTime)
		)
	}
}
