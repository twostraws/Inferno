//
// Wind.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A transition that causes images to be removed in random streaks flowing
/// from right to left.
///
/// This works by generating a pseudorandom value for each pixel based
/// on its Y position. This determines how the base progress of the wind effect
/// for each pixel. In order to create the actual effect, we move each vertical
/// line from "fully on the screen" to "fully off the screen" based on the transition
/// progress, using the pseudorandom value as an offset to create a jagged edge.
/// So, although all parts of the transition move at the same speed, they at least
/// have different X positions.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Parameter windSize: How big the wind streaks should be, relative to the view's width.
/// - Returns: The new pixel color.
[[stitchable]] half4 windTransition(float2 position, SwiftUI::Layer layer, float2 size, float amount, float windSize = 0.2) {
    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // These numbers are commonly used to create
    // seemingly random values from non-random inputs,
    // in our case the Y coordinate of the current pixel.
    float random = fract(sin(dot(float2(0, uv.y), float2(12.9898, 78.233))) * 43758.5453);

    // Adjust the horizontal UV coordinate with the wind effect.
    // This step scales uv.x to the range of 0 to 1 - windSize
    // and then shifts it by windSize, so we start with no movement
    // but finish fully off the screen.
    float adjustedX = uv.x * (1 - windSize) + windSize * random;

    // Calculate the offset for the transition based on the amount.
    // This moves the transition effect across the screen, taking
    // into account the need to overshoot fully based on the size
    // of the wind effect.
    float transitionOffset = amount * (1 + windSize);

    // Calculate the transition progress for each pixel.
    // The smoothstep() function smooths the transition between
    // 0 and -windSize, creating a more gradual effect as the
    // transition moves.
    float progress = smoothstep(0, -windSize, adjustedX - transitionOffset);

    // Blend the original color with the transparent color
    // based on the value of progress.
    return mix(layer.sample(position), 0, progress);
}
