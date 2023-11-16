//
// Diamond.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A transition where many diamonds grow upwards to reveal the new content.
///
/// This works by calculating how far this pixel is from the center of its nearest
/// diamond, then either sending back the original color or transparent depending
/// on whether our distance is less than the transition progress. The distance
/// to the diamond is calculated using Manhattan distance.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Parameter circleSize: How big to make the diamonds.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 diamondTransition(float2 position, half4 color, float amount, float diamondSize) {
    // Figure out our position relative to the nearest
    // diamond.
    float2 f = fract(position / diamondSize);

    // Calculate the Manhattan distance from our pixel to
    // the center of the nearest diamond.
    float d = abs(f.x - 0.5) + abs(f.y - 0.5);

    // If the transition has progressed beyond our distance…
    if (d < amount) {
        // Send back the color
        return color;
    } else {
        // Otherwise send back clear.
        return 0;
    }
}
