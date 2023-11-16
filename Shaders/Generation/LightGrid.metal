//
// LightGrid.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// π to a large degree of accuracy.
#define M_PI 3.14159265358979323846264338327950288

/// Creates a grid of multi-colored flashing lights.
///
/// This works by creating a grid of colors by chunking the texture according
/// to the density from the user. Each chunk is then assigned a random color
/// variance using the same sine trick documented in WhiteNoise, which makes
/// it fluctuate differently from other chunks around it.
///
/// We then calculate the color for each chunk by taking a base color and
/// adjusting it based on the random color variance we just calculated, so
/// that each chunk displays a different color. This is done using sin() so we
//get a smooth color modulation.
///
/// Finally, we pulsate each chunk so that it glows up and down, with black space
/// between each chunk to create delineated a light effect. The black space is
/// created using another call to sin() so that the color ramps from 0 to 1 then
/// back down again.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter time: The number of elapsed seconds since the shader was created
/// - Parameter density: How many rows and columns to create. A range of 1 to 50
///   works well; try starting with 8.
/// - Parameter speed: How fast to make the lights vary their color. Higher values
///   cause lights to flash faster and vary in color more. A range of 1 to 20 works well;
///   try starting with 3.
/// - Parameter groupSize: How many lights to place in each group. A range of 1 to 8
///   works well depending on your density; starting with 1.
/// - Parameter brightness: How bright to make the lights. A range of 0.2 to 10 works
///   well; try starting with 3.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 lightGrid(float2 position, half4 color, float2 size, float time, float density, float speed, float groupSize, float brightness) {
    // Calculate our aspect ratio.
    float aspectRatio = size.x / size.y;

    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // Make sure we can create the effect roughly equally no
    // matter what aspect ratio we're in.
    uv.x *= aspectRatio;

    // If it's not transparent…
    if (color.a > 0) {
        // STEP 1: Split the grid up into groups based on user input.
        float2 point = uv * density;

        // STEP 2: Calculate the color variance for each group
        // pick two numbers that are unlikely to repeat.
        float2 nonRepeating = float2(12.9898, 78.233);

        // Assign this pixel to a group number.
        float2 groupNumber = floor(point);

        // Multiply our group number by the non-repeating
        // numbers, then add them together.
        float sum = dot(groupNumber, nonRepeating);

        // Calculate the sine of our sum to get a range
        // between -1 and 1.
        float sine = sin(sum);

        // Multiply the sine by a big, non-repeating number
        // so that even a small change will result in
        // a big color jump.
        float hugeNumber = sine * 43758.5453;

        // Calculate the sine of our time and our huge number
        // and map it to the range 0...1.
        float variance = (0.5 * sin(time + hugeNumber)) + 0.5;

        // Adjust the color variance by the provided speed.
        float acceleratedVariance = speed * variance;


        // STEP 3: Calculate the final color for this group.
        // Select a base color to work from.
        half3 baseColor = half3(3, 1.5, 0);

        // Apply our variation to the base color, factoring in time.
        half3 variedColor = baseColor + acceleratedVariance + time;

        // Calculate the sine of our varied color so it has
        // the range -1 to 1.
        half3 variedColorSine = sin(variedColor);

        // Adjust the sine to lie in the range 0...1.
        half3 newColor = (0.5h * variedColorSine) + 0.5h;


        // STEP 4: Now we know the color, calculate the color pulse
        // Start by moving down and left a little to create black
        // lines at intersection points.
        float2 adjustedGroupSize = M_PI * 2 * groupSize * (point - (0.25 / groupSize));

        // Calculate the sine of our group size, then adjust it
        // to lie in the range 0...1.
        float2 groupSine = (0.5 * sin(adjustedGroupSize)) + 0.5;

        // Use the sine to calculate a pulsating value between
        // 0 and 1, making our group fluctuate together.
        float2 pulse = smoothstep(0, 1, groupSine);

        // Calculate the final color by combining the pulse
        // strength and user brightness with the color
        // for this square.
        return half4(newColor * pulse.x * pulse.y * brightness, 1) * color.a;
    } else {
        // Use the current (transparent) color.
        return color;
    }
}
