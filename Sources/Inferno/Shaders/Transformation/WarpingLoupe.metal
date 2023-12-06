//
// WarpingLoupe.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A shader that creates a circular zoom effect over a precise location, with
/// variable zoom around the touch area to create a glass orb-like effect.
///
/// This works identically to the simple loupe shader, except that we add back
/// to the zoom some amount of our distance. This means that pixels directly under
/// the user's finger have 0.5 zoom (e.g. half a pixel being stretched to fit the space
/// allocated to 1 pixel), but pixels that are increasingly far away (but still within the
/// maximum distance) are stretched less.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter touch: The location the user is touching, where the zoom should be centered.
/// - Parameter maxDistance: How large the loupe zoom area should be.
///   Try starting with 0.05.
/// - Parameter zoomFactor: How much to zoom the contents of the loupe.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 warpingLoupe(float2 position, SwiftUI::Layer layer, float2 size, float2 touch, float maxDistance, float zoomFactor) {
    // Calculate our coordinate in UV space, 0 to 1.
    half2 uv = half2(position / size);

    // Figure out where the user's touch is in UV space.
    half2 center = half2(touch / size);

    // Calculate how far this pixel is from the touch.
    half2 delta = uv - center;

    // Make sure we can create a round loupe even in views
    // that aren't square.
    half aspectRatio = size.x / size.y;

    // Figure out the squared Euclidean distance from
    // this pixel to the touch, factoring in aspect ratio.
    half distance = (delta.x * delta.x) + (delta.y * delta.y) / aspectRatio;

    // Show 1 pixel in the space by default.
    half totalZoom = 1.0h;

    // If we're inside the loupe area…
    if (distance < maxDistance) {
        // Halve the number of pixels we're showing – stretch
        // the pixels upwards to fill the same space.
        totalZoom /= zoomFactor;

        // Add back to the zoom some amount of the distance,
        // causing the zoom effect to lessen as pixels are
        // further from the touch point.
        float zoomAdjustment = smoothstep(0.0h, half(maxDistance), distance);
        totalZoom += zoomAdjustment / 2.0h;
    }

    // Calculate the new pixel to read by applying that zoom
    // to the distance from the pixel to the touch, then
    // offsetting it back to the center.
    half2 newPosition = delta * totalZoom + center;

    // Sample and return that color, taking the position
    // back to user space.
    return layer.sample(float2(newPosition) * size);
}


