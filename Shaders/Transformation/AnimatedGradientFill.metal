//
// AnimatedGradientFill.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that generates a constantly cycling color gradient, centered
/// on the input view.
///
/// This works be calculating the angle from center  of our input view
/// to the current pixel, then using that angle to create RGB values.
/// Using abs() for those color components ensures all values lie in
/// the range 0 to 1.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Returns: The new pixel color.
[[ stitchable ]] half4 animatedGradientFill(float2 position, half4 color, float2 size, float time) {
    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // Get the same UV in the range -1 to 1, so that
    // 0 is in the center.
    float2 rp = uv * 2 - 1;

    // Calculate the angle top this pixel, adding in time
    // so it's constantly changing.
    float angle = atan2(rp.y, rp.x) + time;

    // Send back variations on the sine of that angle, so we
    // get a range of colors. The use of abs() here avoids
    // negative values for any color component.
    return half4(abs(sin(angle)), abs(sin(angle + 2)), abs(sin(angle + 4)), color.a) * color.a;
}
