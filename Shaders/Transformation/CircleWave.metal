//
// CircleWave.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// A shader that generates circular waves moving out or in, with varying
/// size, brightness, speed, strength, and more.
///
/// This works by calculating what a color gradient would look like over the space
/// of the view, then calculating the pixel's distance from the center of the wave.
/// From there we can calculate the brightness of the pixel by taking the cosine of
/// the wave density and speed to create a nice and smooth effect.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter time: The number of elapsed seconds since the shader was created.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter brightness:  How bright the colors should be. Ranges from 0 to 5 work
///   best; try starting with 0.5 and experiment.
/// - Parameter speed: How fast the wave should travel. Ranges from -2 to 2 work best,
///   where negative numbers cause waves to come inwards; try starting with 1.
/// - Parameter strength: How intense the waves should be. Ranges from 0.02 to 5 work
///   best; try starting with 2.
/// - Parameter density: How large each wave should be. Ranges from 20 to 500 work
///   best; try starting with 100.
/// - Parameter center: The center of the effect, where 0.5/0.5 is dead center
/// - Parameter circleColor: The color to use for the waves. Use darker colors to create
///   a less intense core.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 circleWave(float2 position, half4 color, float2 size, float time, float brightness, float speed, float strength, float density, float2 center, half4 circleColor) {
    // If it's not transparent…
    if (color.a > 0.0h) {
        // Calculate our coordinate in UV space, 0 to 1.
        half2 uv = half2(position / size);

        // Calculate how far this pixel is from the center point.
        half2 delta = uv - half2(center);

        // Make sure we can create round circles even in views
        // that aren't square.
        half aspectRatio = size.x / size.y;

        // Add the aspect ratio correction to our distance.
        delta.x *= aspectRatio;

        // Euclidean distance from our pixel to the center
        // of the circle.
        half pixelDistance = sqrt((delta.x * delta.x) + (delta.y * delta.y));

        // Calculate how fast to make the waves move; this
        // is negative so the waves move outwards with a
        // positive speed.
        half waveSpeed = -(time * speed * 10.0h);

        // Create RGB colors from the provided brightness.
        half3 newBrightness = half3(brightness);

        // Create a gradient by combining our R color with G
        // and B values calculated using our texture coordinate,
        // then multiply the result by the provided brightness.
        half3 gradientColor = half3(circleColor.r, circleColor.g, circleColor.b) * newBrightness;

        // Calculate how much color to apply to this pixel
        // by cubing its distance from the center.
        half colorStrength = pow(1.0h - pixelDistance, 3.0h);

        // Multiply by the user's input strength.
        colorStrength *= strength;

        // Calculate the size of our wave by multiplying
        // provided density with our distance from the center.
        half waveDensity = density * pixelDistance;

        // Decide how dark this pixel should be as a range
        // from -1 to 1 by adding the speed of the overall
        // wave by the density of the current pixel.
        half cosine = cos(waveSpeed + waveDensity);

        // Halve that cosine and add 0.5, which will give a 
        // range of 0 to 1. This is our wave fluctuation,
        // which causes waves to vary between colored and dark.
        half cosineAdjustment = (0.5h * cosine) + 0.5h;

        // Calculate the brightness for this pixel by
        // multiplying its color strength with the sum
        // of the user's requested strength and our cosine
        // adjustment.
        half luma = colorStrength * (strength + cosineAdjustment);

        // Force the brightness to decay rapidly so we
        // don't hit the edges of our sprite.
        luma *= 1.0h - (pixelDistance * 2.0h);
        luma = max(0.0h, luma);

        // Multiply our gradient color by brightness for RGB,
        // and the brightness itself for A.
        half4 finalColor = half4(gradientColor * luma, luma);

        // Multiply the final color by the input alpha, to
        // get smooth edges.
        return finalColor * color.a;
    } else {
        // Use the current (transparent) color.
        return color;
    }
}
