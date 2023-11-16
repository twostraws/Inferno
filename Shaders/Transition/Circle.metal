//
// Circle.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A transition where many circles grow upwards to reveal the new content.
///
/// This works by calculating how far this pixel is from the center of its nearest
/// circle, then either sending back the original color or transparent depending
/// on whether our distance is less than the transition progress.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Parameter circleSize: How big to make the circles.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 circleTransition(float2 position, half4 color, float amount, float circleSize) {
    // Figure out our position relative to the nearest
    // circle.
    float2 f = fract(position / circleSize);

    // Calculate the Euclidean distance from this pixel
    // to the center of the nearest circle.
    float d = distance(f, 0.5);

    // If the transition has progressed beyond our distance,
    // factoring in our X/Y UV coordinate…
    if (d < amount) {
        // Send back the color
        return color;
    } else {
        // Otherwise send back clear.
        return 0;
    }
}
