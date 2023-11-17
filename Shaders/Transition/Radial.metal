//
// Radial.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A transition that mimics a radial wipe.
///
/// This works by calculating the angle from the center of the input view
/// to this pixel, offsetting it by 90 degrees (π ÷ 2) so that our transition
/// begins from the top. Once we know that angle, we can figure out whether
/// this pixel lies in a part of the transition that has yet to be wiped or not.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Returns: The new pixel color.
[[stitchable]] half4 radialTransition(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
    // Calculate our coordinate in UV space, 0 to 1.
    half2 uv = half2(position / size);

    // Get the same UV in the range -1 to 1, so that
    // 0 is in the center.
    half2 rp = uv * 2.0h - 1.0h;

    // Read the current color of this pixel.
    half4 currentColor = layer.sample(position);

    // Calculate the angle to this pixel, adjusted by
    // half π (90 degrees) so our transition starts
    // directly up rather than to the left.
    half angle = atan2(rp.y, rp.x) + M_PI_2_H;

    // Wrap the angle around so it's always in the 
    // range 0...2π.
    if (angle < 0.0h) angle += M_PI_H * 2.0h;

    // Rotate clockwise rather than anti-clockwise.
    angle = M_PI_H * 2.0h - angle;

    // Calculate how far this pixel is through the transition.
    half progress = smoothstep(0.0h, 1.0h, angle - (half(amount) - 0.5h) * M_PI_H * 4.0h);

    // Send back a blend between transparent and the original
    // color based on the progress.
    return mix(0.0h, currentColor, progress);
}
