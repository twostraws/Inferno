//
// ColorPlanes.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A shader that separates the RGB values for a pixel and offsets them to create
/// a glitch-style effect.
///
/// This works by reading different pixels than the original for both the red
/// and blue color components, offsetting them by the `offset` value
/// and a fixed multiplier. So, for a pixel at (100, 100) with an `offset`
/// of 10, we would use the original green and alpha values at that location,
/// but offset the red by (20, 20) and the blue by (10, 10) – we would use
/// the red value from (120, 120) and the blue value from (110, 110).
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter offset: How much to offset colors by.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 colorPlanes(float2 position, SwiftUI::Layer layer, float2 offset) {
    // Our red value should be read from double our offset.
    float2 red = position - (offset * 2.0);

    // Our blue value should be read from our offset.
    float2 blue = position - offset;

    // Read the green value from the actual position.
    half4 color = layer.sample(position);

    // Make our color use the value at the red location.
    color.r = layer.sample(red).r;

    // The same, for the blue location.
    color.b = layer.sample(blue).b;

    // Send back the result, factoring in the original alpha
    // to get smoother edges.
    return color * color.a;
}
