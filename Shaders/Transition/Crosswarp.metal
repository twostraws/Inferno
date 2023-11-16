//
// Crosswarp.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A transition that stretches and fades pixels starting from the right edge.
///
/// This is actually two transitions paired together, so we can combine them to make
/// views move in unison. Both work in roughly the same way: we figure out how
/// far the current pixel is through the overall transition, using smoothstep()
/// to make sure we clamp the range to 0...1, and add some gentle easing.
///
/// Once we have that, we decide which pixel to read by mixing our original
/// pixel position with (0.5, 0.5), the center of the image, based on the pixel
/// transition amount, meaning that at amount 0 we use our original pixel location
/// at amount 1 we use the center, and all intermediate values use some blend
/// of the two.
///
/// Now we know which pixel to sample, we mix that the transparent color
/// based on the same transition amount, causing the pixels to fade out.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Returns: The new pixel color.
[[stitchable]] half4 crosswarpLTRTransition(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // Calculate how far this pixel is through the
    // transition. When amount is 0, the left edge will
    // be -1 and the right edge will be 0. When amount is
    // 0.5, the left edge will be 0, and the right edge
    // will be 1. When amount is 1, the left edge will be
    // 1, and the right edge 2.
    float progress = amount * 2 + uv.x - 1;

    // Move smoothly between 0 and 1 with easing, making
    // sure to clamp to 0 and 1 at the same time.
    float x = smoothstep(0, 1, progress);

    // We want to read pixels increasingly close to the
    // center of our texture as the transition progresses.
    // So, we mix our original UV with (0.5, 0.5) based
    // on the value of x computed above.
    float2 newPosition = mix(uv, float2(0.5), x);

    // Now blend the pixel at that location with the clear
    // color based on x, so we fade out over time.
    return mix(layer.sample(newPosition * size), 0, x);
}

/// A transition that stretches and fades pixels starting from the left edge.
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Returns: The new pixel color.
[[stitchable]] half4 crosswarpRTLTransition(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // Calculate how far this pixel is through the
    // transition. When amount is 0, the left edge will
    // be 0 and the right edge will be -1. When amount is
    // 0.5, the left edge will be 1, and the right edge
    // will be 0. When amount is 1, the left edge will be
    // 2, and the right edge 1.
    float progress = amount * 2 + (1 - uv.x) - 1;

    // Move smoothly between 0 and 1 with easing, making
    // sure to clamp to 0 and 1 at the same time.
    float x = smoothstep(0, 1, progress);

    // We want to read pixels increasingly close to the
    // original position as the transition progresses.
    // So, we move the UV origin towards the center,
    // scale the value upwards by 1 minus our smoothed
    // progress, then move the UV back to where it was.
    float2 newPosition = (uv - 0.5) * (1 - x) + 0.5;

    // Now blend the pixel at that location with the clear
    // color based on x, so we fade out over time.
    return mix(layer.sample(newPosition * size), 0, x);
}
