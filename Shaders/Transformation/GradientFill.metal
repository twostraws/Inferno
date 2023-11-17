//
// GradientFill.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A shader that generates a gradient fill.
///
/// This creates a diagonal gradient effect by calculating unique red and blue values
/// by dividing the X/Y and Y/X position of the pixel respectively.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel, used for alpha calculations.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 gradientFill(float2 position, half4 color) {
    // Send back a new color based on the position of the pixel
    // factoring in the original alpha to get smooth edges.
    return half4(position.x / position.y, 0.0h, position.y / position.x, 1.0h) * color.a;
}
