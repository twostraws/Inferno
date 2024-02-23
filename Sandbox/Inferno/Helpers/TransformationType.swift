//
// TransformationType.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import Foundation


/// Contains the various different effects we want to apply.
enum TransformationType {
    /// Applies a `colorEffect()` modifier.
    case colorEffect

    /// Applies a `distortionEffect()` modifier.
    case distortionEffect

    /// Applies a `visualEffect()` modifier, with
    /// a `colorEffect()` modifier nested inside.
    case visualEffectColor

    /// Applies a `visualEffect()` modifier, with
    /// a `distortionEffect()` modifier nested inside.
    case visualEffectDistortion
}
