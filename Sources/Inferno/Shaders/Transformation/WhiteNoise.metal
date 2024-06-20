//
// WhiteNoise.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A simple function that attempts to generate a random number based on various
/// fixed input parameters.
/// A simple function that attempts to generate a random number based on various
/// fixed input parameters.

half4 randomNoise(
    float2 position, /// The position in 2D space for which we're generating noise
    half4 color,     /// The base color that will be modified by the noise
    float time       /// The current time, used to animate the noise
) {
    // Generate a pseudo-random value based on the position and time.
    // `dot(position + time, float2(12.9898, 78.233))` computes a dot product which helps in producing a pseudo-random effect.
    // `sin(...) * 43758.5453` creates further randomness.
    // `fract(...)` ensures that the value stays within the range [0, 1] by returning the fractional part.
    float value = fract(sin(dot(position + time, float2(12.9898, 78.233))) * 43758.5453);
    
    // Create a color based on the generated noise value.
    // The resulting color is grayscale because all RGB components are set to the same value.
    // The alpha channel is set to 1.
    // The final result is multiplied by the alpha of the input color to maintain its transparency.
    return half4(value, value, value, 1) * color.a;
}

