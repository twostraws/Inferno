//
// Infrared.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//
#include <metal_stdlib>
using namespace metal;

/// A shader that creates simulated infrared colors by replacing bright colors with
/// blends of red and yellow, and darker colors with blends of yellow and blue.
///
/// This works by calculating the brightness of the current color, then creating a new
/// color based on that brightness. If the brightness is lower than 0.5 on a scale of
/// 0 to 1, the new color is a mix of blue and yellow based; if the brightness is 0.5 or
/// higher, the new color is a mix of yellow and red.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 infrared(float2 position, half4 color) {
    // If it's not transparent…
    if (color.a > 0) {
        // Create three colors: blue (cold), yellow (medium), and hot (red).
        half3 cold = half3(0.0h, 0.0h, 1.0h);
        half3 medium = half3(1.0h, 1.0h, 0.0h);
        half3 hot = half3(1.0h, 0.0h, 0.0h);

        // These values correspond to how important each
        // color is to the overall brightness. The total
        // is 1.
        half3 grayValues = half3(0.2125h, 0.7154h, 0.0721h);

        // The dot() function multiplies all the colors
        // in our source color with all the values in
        // our grayValues conversion then sums them.
        // This means that `luma` will be a number
        // between 0 and 1, based on the input RGB
        // values and their relative brightnesses.
        half luma = dot(color.rgb, grayValues);

        // Declare the color we're going to use.
        half3 newColor;

        // If we have brightness of lower than 0.5…
        if (luma < 0.5h) {
            // Create a mix of blue and yellow; luma / 0.5 means this will be a range from 0 to 1.
            newColor = mix(cold, medium, luma / 0.5h);
        } else {
            // Create a mix of yellow and red; (luma - 0.5) / 0.5 means this will be a range of 0 to 1.
            newColor = mix(medium, hot, (luma - 0.5h) / 0.5h);
        }

        // Create the final color, multiplying by this
        // pixel's alpha (to avoid a hard edge).
        return half4(newColor, 1.0h) * color.a;
    } else {
        // Use the current (transparent) color.
        return color;
    }
}
