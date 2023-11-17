//
// InvertAlpha.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that inverts the alpha of an image, replacing transparent colors with
/// a supplied color.
///
/// This sends back the original RGB values for the color, but subtracts the current
/// alpha from 1 to invert it. So, if the alpha was 1 it becomes 0, if the alpha was
/// 0 it becomes 1, and so on.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter replacement: The replacement color to use for pixels.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 invertAlpha(float2 position, half4 color, half4 replacement) {
    // Send back the RGB values from our input pixel, but
    // flip the alpha value around.
    return half4(replacement.rgb, 1.0h) * (1.0h - color.a);
}
