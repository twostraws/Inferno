//
// Recolor.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that changes texture colors to a replacement, while respecting the
/// current alpha value.
///
/// This works by replacing all colors with the replacement color, but also taking into
/// account the alpha value of the current color so we respect transparency.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter replacement: The new color to use in place of the current color.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 recolor(float2 position, half4 color, half4 replacement) {
    // Send back the RGB values from the replacement color
    // factoring in the original alpha to preserve opacity.
    return replacement * color.a;
}
