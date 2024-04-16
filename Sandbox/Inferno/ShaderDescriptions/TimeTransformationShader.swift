//
// TimeTransformationShader.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import Inferno
import SwiftUI

/// A shader that accepts a time input value so that its effect changes over time.
struct TimeTransformationShader: Hashable, Identifiable {
    /// The unique, random identifier for this shader, so we can show these
    /// things in a loop.
    var id = UUID()
    
    /// The human-readable name for this shader. This must work with the
    /// String-ShaderName extension so the name matches the underlying
    /// Metal shader function name.
    var name: String
    
    /// What kind of SwiftUI modifier needs to be applied to create this shader.
    /// There's no default value here, because there is so much variation.
    var type: TransformationType

    /// Some shaders need completely custom initialization, so this is effectively
    /// a trap door to allow that to happen rather than squeeze all sorts of
    /// special casing into the code.
    var initializer: ((_ time: Double, _ size: CGSize) -> Shader)?

    /// We need a custom equatable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    static func ==(lhs: TimeTransformationShader, rhs: TimeTransformationShader) -> Bool {
        lhs.id == rhs.id
    }

    /// We need a custom hashable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Creates the correct shader for this object, passing in the amount of time
    /// that has elapsed since the shader was created.
    func createShader(elapsedTime: Double) -> Shader {
        if let initializer {
            return initializer(elapsedTime, .zero)
        } else {
            let shader = InfernoShaderLibrary[dynamicMember: name.shaderName]
            return shader(
                .float(elapsedTime)
            )
        }
    }

    /// Creates the correct shader for this object, passing in the the current
    /// size of the SwiftUI view it's applied to, and also the amount of time
    /// that has elapsed since the shader was created.
    func createShader(elapsedTime: Double, size: CGSize) -> Shader {
        if let initializer {
            return initializer(elapsedTime, size)
        } else {
            let shader = InfernoShaderLibrary[dynamicMember: name.shaderName]

            return shader(
                .float2(size),
                .float(elapsedTime)
            )
        }
    }

    /// An example shader used for Xcode previews.
    static let example = shaders[0]

    /// All the time transformation shaders we want to show.
    static let shaders = [
        TimeTransformationShader(name: "Animated Gradient Fill", type: .visualEffectColor),
        TimeTransformationShader(name: "Circle Wave", type: .visualEffectColor) { time, size in
            let shader = InfernoShaderLibrary[dynamicMember: "circleWave"]

            // This is such a great shader, but trying to squeeze
            // all these options into the main sandbox UI would
            // have caused all sorts of headaches. So, we use
            // custom initialization to inject sensible values
            // and the user (that's you!) can just manipulate
            // these however they want.
            return shader(
                .float2(size),
                .float(time),
                .float(0.5),
                .float(1),
                .float(2),
                .float(100),
                .float2(0.5, 0.5),
                .color(.green)
            )
        },
        TimeTransformationShader(name: "Rainbow Noise", type: .colorEffect),
        TimeTransformationShader(name: "Relative Wave", type: .visualEffectDistortion) { time, size in
            let shader = InfernoShaderLibrary[dynamicMember: "relativeWave"]

            return shader(
                .float2(size),
                .float(time),
                .float(5),
                .float(20),
                .float(5)
            )
        },
        TimeTransformationShader(name: "Shimmer", type: .visualEffectColor) { time, size in
            let shader = InfernoShaderLibrary[dynamicMember: "shimmer"]
            
            return shader(
                .float2(size),
                .float(time),
                .float(3.0),
                .float(0.3),
                .float(0.9)
           )
        },
        TimeTransformationShader(name: "Water", type: .visualEffectDistortion) { time, size in
            let shader = InfernoShaderLibrary[dynamicMember: "water"]

            return shader(
                .float2(size),
                .float(time),
                .float(3),
                .float(3),
                .float(10)
            )
        },
        TimeTransformationShader(name: "Wave", type: .distortionEffect) { time, _ in
            let shader = InfernoShaderLibrary[dynamicMember: "wave"]

            return shader(
                .float(time),
                .float(5),
                .float(10),
                .float(5)
            )
        },
        TimeTransformationShader(name: "White Noise", type: .colorEffect)
    ]
}
