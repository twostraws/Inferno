//
// Water.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that generates a water effect.
///
/// This works by pushing pixels around based on a simple algorithm: we pass
/// the original coordinate, speed, and frequency into the sin() and cos() functions
/// to get different numbers between -1 and 1, then multiply that by the user's
/// strength parameter to see how far away we should be moved.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter speed: How fast to make the water ripple. Ranges from 0.5 to 10
///   work best; try starting with 3.
/// - Parameter strength: How pronounced the rippling effect should be.
///   Ranges from 1 to 5 work best; try starting with 3.
/// - Parameter frequency: How often ripples should be created. Ranges from
///   5 to 25 work best; try starting with 10.
/// - Returns: The new pixel color.
[[ stitchable ]] float2 water(float2 position, float2 size, float time, float speed, float strength, float frequency) {
    // Calculate our coordinate in UV space, 0 to 1.
    half2 uv = half2(position / size);

    // Bring both speed and strength into the kinds of
    // ranges we need for this effect.
    half adjustedSpeed = time * speed * 0.05h;
    half adjustedStrength = strength / 100.0h;

    // Offset the coordinate by a small amount in each
    // direction, based on wave frequency and wave strength.
    uv.x += sin((uv.x + adjustedSpeed) * frequency) * adjustedStrength;
    uv.y += cos((uv.y + adjustedSpeed) * frequency) * adjustedStrength;

    // Bring the position back up to user-space coordinates.
    return float2(uv) * size;
}
