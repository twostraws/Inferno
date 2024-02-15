//
// TouchTransformationShader.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import Inferno
import SwiftUI

/// A shader that accepts the location of a user touch, using that to control
/// the shader effect somehow.
struct TouchTransformationShader: Hashable, Identifiable {
    /// The unique, random identifier for this shader, so we can show these
    /// things in a loop.
    var id = UUID()
    
    /// The human-readable name for this shader. This must work with the
    /// String-ShaderName extension so the name matches the underlying
    /// Metal shader function name.
    var name: String
    
    /// Whether this shader needs to know the size of the image it's working with.
    var usesSize: Bool

    /// When provided, what range of values should be proposed to the user
    /// to control this shader.
    var valueRange: ClosedRange<Double>?

    /// Some shaders need completely custom initialization, so this is effectively
    /// a trap door to allow that to happen rather than squeeze all sorts of
    /// special casing into the code.
    var initializer: ((_ size: CGSize, _ touch: CGPoint, _ value: Double) -> Shader)?

    /// We need a custom equatable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    static func ==(lhs: TouchTransformationShader, rhs: TouchTransformationShader) -> Bool {
        lhs.id == rhs.id
    }

    /// We need a custom hashable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Creates the correct shader for this object, passing in the current
    /// touch location.
    func createShader(touchLocation: CGPoint, value: Double) -> Shader {
        if let initializer {
            return initializer(.zero, touchLocation, value)
        } else {
            let shader = InfernoShaderLibrary[dynamicMember: name.shaderName]

            if valueRange != nil {
                return shader(
                    .float2(touchLocation),
                    .float(value)
                )
            } else {
                return shader(
                    .float2(touchLocation)
                )
            }
        }
    }

    /// Creates the correct shader for this object, passing in the current
    /// size of the SwiftUI view it's applied to, as well as the current
    /// touch location.
    func createShader(size: CGSize, touchLocation: CGPoint, value: Double) -> Shader {
        if let initializer {
            return initializer(size, touchLocation, value)
        } else {
            let shader = InfernoShaderLibrary[dynamicMember: name.shaderName]

            if valueRange != nil {
                return shader(
                    .float2(size),
                    .float2(touchLocation)
                )
            } else {
                return shader(
                    .float2(size),
                    .float2(touchLocation),
                    .float(value)
                )
            }
        }
    }

    /// An example shader used for Xcode previews.
    static let example = shaders[0]

    /// All the touch transformation shaders we want to show.
    static let shaders = [
        TouchTransformationShader(name: "Color Planes", usesSize: false),
        TouchTransformationShader(name: "Simple Loupe", usesSize: true, valueRange: 0.001...0.1) { size, touch, value in
            let shader = InfernoShaderLibrary[dynamicMember: "simpleLoupe"]

            return shader(
                .float2(size),
                .float2(touch),
                .float(value),
                .float(2)
            )
        },
        TouchTransformationShader(name: "Warping Loupe", usesSize: true, valueRange: 0.001...0.1) { size, touch, value in
            let shader = InfernoShaderLibrary[dynamicMember: "warpingLoupe"]

            return shader(
                .float2(size),
                .float2(touch),
                .float(value),
                .float(2)
            )
        },
        TouchTransformationShader(name: "Bubble", usesSize: true, valueRange: 10...100) { size, touch, value in
          let shader = InfernoShaderLibrary[dynamicMember: "bubble"]

            return shader(
                .float2(size),
                .float2(touch),
                .float(value)
            )
        }
    ]
}
