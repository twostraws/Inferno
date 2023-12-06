//
// RelativeWave.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that generates a wave effect, where no effect is applied on the left
/// side of the input, and the full effect is applied on the right side.
///
/// This works by offsetting the Y position of each pixel by some amount of its X
/// position. Using sin() for this generates values between -1 and 1, but this then
/// gets multiplied by 10 to increase the strength. The final amount to offset is
/// multiplied by the distance from the left edge in UV space, meaning that pixels
/// near the left edge are moved much less than pixels near the right edge.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter speed: How fast to make the waves ripple. Try starting with a value of 5.
/// - Parameter smoothing: How much to smooth out the ripples, where greater values
///   produce a smoother effect. Try starting with a value of 20.
/// - Parameter strength: How pronounced to make the ripple effect. Try starting with a
///   value of 10.
/// - Returns: The new pixel color.
[[ stitchable ]] float2 relativeWave(float2 position, float2 size, float time, float speed, float smoothing, float strength) {
    // Calculate our coordinate in UV space, 0 to 1.
    half2 uv = half2(position / size);

    // Offset our Y value by some amount of our X position.
    // Using time * 5 speeds up the wave, and dividing the
    // X position by 20 smooths out the wave to avoid jaggies.
    half offset = sin(time * speed + position.x / smoothing);

    // Apply some amount of that offset based on how far we
    // are from the leading edge.
    position.y += offset * uv.x * strength;

    // Send back the offset position.
    return position;
 }
