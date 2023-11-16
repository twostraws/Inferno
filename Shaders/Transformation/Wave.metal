//
// Wave.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that generates a uniform wave effect.
///
/// This works by offsetting the Y position of each pixel by some amount of its X
/// position. Using sin() for this generates values between -1 and 1, but this then
/// gets multiplied by 10 to increase the strength.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Parameter speed: How fast to make the waves ripple. Try starting with a value of 5.
/// - Parameter smoothing: How much to smooth out the ripples, where greater values
///   produce a smoother effect. Try starting with a value of 20.
/// - Parameter strength: How pronounced to make the ripple effect. Try starting with a
///   value of 5.
/// - Returns: The new pixel color.
[[ stitchable ]] float2 wave(float2 position, float time, float speed, float smoothing, float strength) {
    // Offset our Y value by some amount of our X position.
    // Using time * 5 speeds up the wave, and dividing the
    // X position by 20 smooths out the wave to avoid jaggies.
    position.y += sin(time * speed + position.x / smoothing) * strength;

    // Send back the offset position.
    return position;
}
