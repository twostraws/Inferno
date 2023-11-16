//
// CircleWave.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A transition where many circles grow upwards to reveal the new content,
/// with the circles moving outwards from the top-left edge.
///
/// This works works identically to the circle transition, except it factors in the
/// X and Y coordinate of the current pixel. This means pixels in the top-left
/// of the source layer will transition first, because their UV positions are closer
/// to (0, 0).
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Parameter circleSize: How big to make the circles.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 circleWaveTransition(float2 position, half4 color, float2 size, float amount, float circleSize) {
    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // Figure out our position relative to the nearest
    // circle.
    float2 f = fract(position / circleSize);

    // Calculate the Euclidean distance from this pixel
    // to the center of the nearest circle.
    float d = distance(f, 0.5);

    // If the transition has progressed beyond our distance,
    // factoring in our X/Y UV coordinate…
    if (d + uv.x + uv.y < amount * 3) {
        // Send back the color
        return color;
    } else {
        // Otherwise send back clear.
        return 0;
    }
}
