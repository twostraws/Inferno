//
// SimpleLoupe.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A shader that creates a circular zoom effect over a precise location.
///
/// This works by calculating how far the user's touch is from the current pixel,
/// and, if it is within a certain distance, causing it to be zoomed. The default zoom
/// is 1, meaning that 1 pixel should be drawn in the space allocated to 1 pixel. If the
/// zoom goes down to 0.5, it means 0.5 pixels should be drawn in the space allocated
/// to 1 pixel, causing it to be stretched.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter touch: The location the user is touching, where the zoom should be centered.
/// - Parameter maxDistance: How large the loupe zoom area should be.
///   Try starting with 0.05.
/// - Parameter zoomFactor: How much to zoom the contents of the loupe.
///   Try starting with 2.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 simpleLoupe(float2 position, SwiftUI::Layer layer, float2 size, float2 touch, float maxDistance, float zoomFactor) {
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
    }

    // Calculate the new pixel to read by applying that zoom
    // to the distance from the pixel to the touch, then
    // offsetting it back to the center.
    half2 newPosition = delta * totalZoom + center;

    // Sample and return that color, taking the position
    // back to user space.
    return layer.sample(float2(newPosition) * size);
}
