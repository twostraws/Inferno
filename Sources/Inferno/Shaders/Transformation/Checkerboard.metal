//
// Checkerboard.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that replaces the current image with a checkerboard pattern,
/// flipping between an input color and a replacement.
///
/// This works by dividing our pixel position by the square size, then casting the
/// result to an integer to round it downwards. It then uses XOR with the resulting
/// X/Y value to figure out if exactly one of those values ends in a 1, and if it does
/// sends back the replacement color. So, if we're in row 0 and column 1 it will send
/// back the replacement color, as will row 1 column 0, but row 0/column 0 and
/// row 1/column 1 will both send back the original value.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter replacement: The replacement color to be used for checkered squares.
/// - Parameter size: The size of the whole image, in user-space.
/// - Returns: The new pixel color, either the replacement color or clear.
[[ stitchable ]] half4 checkerboard(float2 position, half4 color, half4 replacement, float size) {
    // Calculate which square of the checkerboard we're in,
    // rounding values down.
    uint2 posInChecks = uint2(position.x / size, position.y / size);

    // XOR our X and Y position, then check if the result
    // is odd.
    bool isColor = (posInChecks.x ^ posInChecks.y) & 1;

    // If it's odd send back the replacement color,
    // otherwise send back the original
    return isColor ? replacement * color.a : color;
}
