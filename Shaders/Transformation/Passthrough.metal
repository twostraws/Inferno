//
// Passthrough.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that outputs the same color it was provided with.
///
/// This shader does nothing at all. It's helpful to include as an example
/// shader, or to disable another shader you had selected.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Returns: The original pixel color.
[[ stitchable ]] half4 passthrough(float2 position, half4 color) {
    // Just send back to the current color as the new color.
    return color;
}
