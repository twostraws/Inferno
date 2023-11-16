//
// Sinebow.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that generates multiple twisting and turning lines that cycle through colors.
///
/// This shader calculates how far each pixel is from one of 10 lines.
/// Each line has its own undulating color and position based on various
/// sine waves, so the pixel's color is calculating by starting from black
/// and adding in a little of each line's color based on its distance.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Returns: The new pixel color.
[[ stitchable ]] half4 sinebow(float2 position, half4 color, float2 size, float time) {
    // Calculate our aspect ratio.
    float aspectRatio = size.x / size.y;

    // Calculate our coordinate in UV space, -1 to 1.
    float2 uv = (position / size.x) * 2 - 1;

    // Make sure we can create the effect roughly equally no
    // matter what aspect ratio we're in.
    uv.x /= aspectRatio;

    // Calculate the overall wave movement.
    float wave = sin(uv.x + time);

    // Square that movement, and multiply by a large number
    // to make the peaks and troughs be nice and big.
    wave *= wave * 50;

    // Assume a black color by default.
    half3 waveColor = half3(0);

    // Create 10 lines in total.
    for (float i = 0; i < 10; i++) {
        // The base brightness of this pixel is 1%, but we
        // need to factor in the position after our wave
        // calculation is taken into account. The abs()
        // call ensures negative numbers become positive,
        // so we care about the absolute distance to the
        // nearest line, rather than ignoring values that
        // are negative.
        float luma = abs(1 / (100 * uv.y + wave));

        // This calculates a second sine wave that's unique
        // to each line, so we get waves inside waves.
        float y = sin(uv.x * sin(time) + i * 0.2 + time);

        // This offsets each line by that second wave amount,
        // so the waves move non-uniformly.
        uv.y += 0.05 * y;

        // Our final color is based on fixed red and blue
        // values, but green fluctuates much more so that
        // the overall brightness varies more randomly.
        // The * 0.5 + 0.5 part ensures the sin() values
        // are between 0 and 1 rather than -1 and 1.
        half3 rainbow = half3(
            sin(i * 0.3 + time) * 0.5 + 0.5,
            sin(i * 0.3 + 2 + sin(time * 0.3) * 2) * 0.5 + 0.5,
            sin(i * 0.3 + 4) * 0.5 + 0.5
        );

        // Add that to the current wave color, ensuring that
        // pixels receive some brightness from all lines.
        waveColor += rainbow * luma;
    }

    // Send back the finished color, taking into account the
    // current alpha value.
    return half4(waveColor, color.a) * color.a;
}
