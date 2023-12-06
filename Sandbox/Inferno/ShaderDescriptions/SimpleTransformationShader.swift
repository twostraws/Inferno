//
// TransformationShader.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import Inferno
import SwiftUI

/// A small shader that adjusts its input without any further data, e.g. recoloring.
struct SimpleTransformationShader: Hashable, Identifiable {
    /// The unique, random identifier for this shader, so we can show these
    /// things in a loop.
    var id = UUID()
    
    /// The human-readable name for this shader. This must work with the
    /// String-ShaderName extension so the name matches the underlying
    /// Metal shader function name.
    var name: String

    /// What kind of SwiftUI modifier needs to be applied to create this shader.
    var type: TransformationType = .colorEffect

    /// Whether this shader should be given a replacement color as input.
    var usesReplacementColor: Bool

    /// When provided, what range of values should be proposed to the user
    /// to control this shader.
    var valueRange: ClosedRange<Double>?

    /// Some shaders need completely custom initialization, so this is effectively
    /// a trap door to allow that to happen rather than squeeze all sorts of
    /// special casing into the code.
    var initializer: ((_ size: CGSize, _ color: Color, _ value: Double) -> Shader)?

    /// We need a custom equatable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    static func ==(lhs: SimpleTransformationShader, rhs: SimpleTransformationShader) -> Bool {
        lhs.id == rhs.id
    }

    /// We need a custom hashable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Creates the correct shader for this object, taking into account whether
    /// it needs a value range or replacement color. It feels like there ought
    /// to be a better way of doing this!
    func createShader(color: Color, value: Double, size: CGSize = .zero) -> Shader {
        if let initializer {
            return initializer(size, color, value)
        } else {
            let shader = InfernoShaderLibrary[dynamicMember: name.shaderName]

            if valueRange != nil {
                if usesReplacementColor {
                    return shader(
                        .color(color),
                        .float(value)
                    )
                } else {
                    return shader(
                        .float(value)
                    )
                }
            } else {
                if usesReplacementColor {
                    return shader(
                        .color(color)
                    )
                } else {
                    return shader()
                }
            }
        }
    }

    /// An example shader used for Xcode previews.
    static let example = shaders[0]

    /// All the simple transformation shaders we want to show.
    static let shaders = [
        SimpleTransformationShader(name: "Checkerboard", usesReplacementColor: true, valueRange: 1...20),
        SimpleTransformationShader(name: "Emboss", type: .visualEffectDistortion, usesReplacementColor: false, valueRange: 0...20),
        SimpleTransformationShader(name: "Gradient Fill", usesReplacementColor: false),
        SimpleTransformationShader(name: "Infrared", usesReplacementColor: false),
        SimpleTransformationShader(name: "Interlace", usesReplacementColor: true, valueRange: 1...5) { size, color, value in
            let shader = InfernoShaderLibrary[dynamicMember: "interlace"]

            return shader(
                .float(value),
                .color(color),
                .float(1)
            )
        },
        SimpleTransformationShader(name: "Invert Alpha", usesReplacementColor: true),
        SimpleTransformationShader(name: "Passthrough", usesReplacementColor: false),
        SimpleTransformationShader(name: "Recolor", usesReplacementColor: true)
    ]
}
