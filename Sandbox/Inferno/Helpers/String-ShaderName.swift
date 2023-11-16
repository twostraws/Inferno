//
// String-ShaderName.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import Foundation

/// An extension that converts strings to their equivalent shader names.
extension String {
    /// Converts a string to its equivalent Metal shader function name.
    var shaderName: String {
        let camelCase = prefix(1).lowercased() + dropFirst()
        return camelCase.replacing(" ", with: "")
    }
}
