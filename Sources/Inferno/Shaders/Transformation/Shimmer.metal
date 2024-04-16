//
// Shimmer.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

/// Converts a color from RGB to HSL representation.
/// Reference: https://en.wikipedia.org/wiki/HSL_and_HSV
/// - Parameter rgb: A vector representing a color with components (R, G, B).
/// - Returns: A vector representing a color with components (H, S, L).
half3 rgbToHSL(half3 rgb) {
    half min = min3(rgb.r, rgb.g, rgb.b);
    half max = max3(rgb.r, rgb.g, rgb.b);
    half delta = max - min;

    half3 hsl = half3(0.0h, 0.0h, 0.5h * (max + min));
    
    if (delta > 0.0h) {
        if (max == rgb.r) {
            hsl[0] = fmod((rgb.g - rgb.b) / delta, 6.0h);
        } else if (max == rgb.g) {
            hsl[0] = (rgb.b - rgb.r) / delta + 2.0h;
        } else {
            hsl[0] = (rgb.r - rgb.g) / delta + 4.0h;
        }
        hsl[0] /= 6.0h;
        if (hsl[2] > 0.0h && hsl[2] < 1.0h) {
            hsl[1] = delta / (1.0h - abs(2.0h * hsl[2] - 1.0h));
        } else {
            hsl[1] = 0.0h;
        }
    }
    
    return hsl;
}

/// Converts a color from HSL to RGB representation.
/// Reference: https://en.wikipedia.org/wiki/HSL_and_HSV
/// - Parameter hsl: A vector representing a color with components (H, S, L).
/// - Returns: A vector representing a color with components (R, G, B).
half3 hslToRGB(half3 hsl) {
    half c = (1.0h - abs(2.0h * hsl[2] - 1.0h)) * hsl[1];
    half h = hsl[0] * 6.0h;
    half x = c * (1.0h - abs(fmod(h, 2.0h) - 1.0h));
    
    half3 rgb = half3(0.0h, 0.0h, 0.0h);
    
    if (h < 1.0h) {
        rgb = half3(c, x, 0.0h);
    } else if (h < 2.0h) {
        rgb = half3(x, c, 0.0h);
    } else if (h < 3.0h) {
        rgb = half3(0.0h, c, x);
    } else if (h < 4.0h) {
        rgb = half3(0.0h, x, c);
    } else if (h < 5.0h) {
        rgb = half3(x, 0.0h, c);
    } else {
        rgb = half3(c, 0.0h, x);
    }
    
    half m = hsl[2] - 0.5h * c;
    return rgb + m;
}

/// A shader that generates a shimmering effect.
///
/// This works by creating a gradient that moves horizontally across the view,
/// and then uses that gradient to modulate the lightness of the pixel.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel.
/// - Parameter size: The size of the entire view, in user-space.
/// - Parameter time: The number of elapsed seconds since the shader was created.
/// - Parameter animationDuration: The duration of a single loop of the shimmer animation, in seconds.
/// - Parameter gradientWidth: The width of the shimmer gradient in UV space.
/// - Parameter maxLightness: The maximum lightness at the peak of the gradient.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 shimmer(float2 position, half4 color, float2 size, float time, float animationDuration, float gradientWidth, float maxLightness) {
    if (color.a == 0.0h) {
        return color;
    }
    
    // Calculate the current progress of the shimmer animation loop, from 0 to 1
    float loopedProgress = fmod(time, float(animationDuration));
    half progress = loopedProgress / animationDuration;
    
    // Convert coordinate to UV space, 0 to 1.
    half2 uv = half2(position / size);

    // Calculate u beyond the views's edges based on the gradient size
    half minU = 0.0h - gradientWidth;
    half maxU = 1.0h + gradientWidth;
    
    // Based on the current progress and v, calculate the starting and ending u of the gradient
    half start = minU + maxU * progress + gradientWidth * uv.y;
    half end = start + gradientWidth;
    
    if (uv.x > start && uv.x < end) {
        // Determine the pixel's position within the gradient, from 0 to 1
        half gradient = smoothstep(start, end, uv.x);
        // Determine gradient intensity using a sine wave
        half intensity = sin(gradient * M_PI_H);

        // Convert from RGB to HSL
        half3 hsl = rgbToHSL(color.rgb);
        // Modify the lightness component based on intensity
        hsl[2] = hsl[2] + half(maxLightness * (maxLightness > 0.0h ? 1 - hsl[2] : hsl[2])) * intensity;
        // Convert back to RGB
        color.rgb = hslToRGB(hsl);
    }
    
    return color;
}

