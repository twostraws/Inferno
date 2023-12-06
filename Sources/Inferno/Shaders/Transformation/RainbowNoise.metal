//
// RainbowNoise.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A simple function that attempts to generate a random number based on various
/// fixed input parameters.
///
/// This works using a simple (but brilliant!) and well-known trick: if you calculate the
/// dot product of a coordinate with a float2 containing two numbers that are unlikely
/// to repeat, then calculate the sine of that and multiply it by a large number, you'll
/// end up with what looks more or less like random numbers in the fraction
/// digits – i.e., everything after the decimal place.
///
/// This is perfect for our needs: those numbers will already range from 0 to
/// 0.99999... so we can use that for our color value by calling it once for each
/// of the RGB components.
///
/// - Parameter offset: A fixed value that controls pseudorandomness.
/// - Parameter position: The position of the pixel we're working with.
/// - Parameter time: The number of elapsed seconds since the shader was created.
/// - Returns: The original pixel color.
float rainbowRandom(float offset, float2 position, float time) {
    // Pick two numbers that are unlikely to repeat.
    float2 nonRepeating = float2(12.9898 * time, 78.233 * time);

    // Multiply our texture coordinates by the
    // non-repeating numbers, then add them together.
    float sum = dot(position, nonRepeating);

    // calculate the sine of our sum to get a range
    // between -1 and 1.
    float sine = sin(sum);

    // Multiply the sine by a big, non-repeating number
    // so that even a small change will result in a big
    // color jump.
    float hugeNumber = sine * 43758.5453 * offset;

    // Send back just the numbers after the decimal point.
    return fract(hugeNumber);
}


/// A shader that generates dynamic, multi-colored noise.
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Returns: The new pixel color.
[[ stitchable ]] half4 rainbowNoise(float2 position, half4 color, float time) {
    // If it's not transparent…
    if (color.a > 0.0h) {
        // Make a color where the RGB values are the same
        // random number and A is 1; multiply by the
        // original alpha to get smooth edges.
        return half4(
            rainbowRandom(1.23, position, time),
            rainbowRandom(5.67, position, time),
            rainbowRandom(8.90, position, time),
            1.0h
        ) * color.a;
    } else {
        // Use the current (transparent) color.
        return color;
    }
}
