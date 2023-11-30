//
// Interlace.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that applies an interlacing effect where horizontal lines of the
/// original color are separated by lines of another color.
///
/// This works using modulus: if the current pixel's position modulo twice the line
/// width is less than the line width then draw the original color. Otherwise blend the
/// original color with the interlacing color based on the user's provided strength.
///
/// - Parameter width: The width of the interlacing lines. Ranges of 1 to 4 work best;
///   try starting with 1.
/// - Parameter replacement: The color to use for interlacing lines. Try starting with black.
/// - Parameter strength: How much to blend interlaced lines with color. Specify 0
///   (not at all) up to 1 (fully).
/// - Returns: The new pixel color.
[[ stitchable ]] half4 interlace(float2 position, half4 color, float width, half4 replacement, float strength) {
    // If the current color is not transparent…
    if (color.a > 0.0h) {
        // If we are an alternating horizontal line…
        if (fmod(position.y, width * 2.0) <= width) {
            // Render the original color
            return color;
        } else {
            // Otherwise blend the original color with the provided color
            // at whatever strength was requested, multiplying by this pixel's
            // alpha to avoid a hard edge.
            return half4(mix(color, replacement, strength)) * color.a;
        }
    } else {
        // Use the current (transparent) color
        return color;
    }
}
