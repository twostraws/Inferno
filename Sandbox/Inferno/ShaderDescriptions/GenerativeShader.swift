//
// GenerativeShader.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import Inferno
import SwiftUI

/// A shader that generates its contents fully from scratch.
struct GenerativeShader: Hashable, Identifiable {
    /// The unique, random identifier for this shader, so we can show these
    /// things in a loop.
    var id = UUID()

    /// The human-readable name for this shader. This must work with the
    /// String-ShaderName extension so the name matches the underlying
    /// Metal shader function name.
    var name: String

    /// Some shaders need completely custom initialization, so this is effectively
    /// a trap door to allow that to happen rather than squeeze all sorts of
    /// special casing into the code.
    var initializer: ((_ time: Double, _ size: CGSize) -> Shader)?

    /// We need a custom equatable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    static func ==(lhs: GenerativeShader, rhs: GenerativeShader) -> Bool {
        lhs.id == rhs.id
    }

    /// We need a custom hashable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Converts this shader to its Metal shader by resolving its name.
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

    /// All the generative shaders we want to show.
    static let shaders = [
        GenerativeShader(name: "Light Grid") { time, size in
            let shader = InfernoShaderLibrary[dynamicMember: "lightGrid"]

            return shader(
                .float2(size),
                .float(time),
                .float(8),
                .float(3),
                .float(1),
                .float(3)
            )
        },
        GenerativeShader(name: "Sinebow")
    ]
}

