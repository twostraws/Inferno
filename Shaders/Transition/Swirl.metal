//
// Swirl.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// π to a large degree of accuracy.
#define M_PI 3.14159265358979323846264338327950288

/// A transition that causes images to swirl like a vortex as they fade out.
///
/// This starts by calculating how far the current pixel is from the center of
/// the view, which means we apply the effect at varying strengths so that
/// the swirl is stronger at the center than it is further away.
///
/// Once we have that, we decide whether we're swirling up or down. This
/// is because transitions moves through three states: full opaque and unswirled,
/// half visible and fully swirled, then fully transparent and unswirled.
///
/// Finally we need to figure out what to pixel value to send back. This is done
/// by rotating the original coordinate by some amount based on where
/// we are in the swirl (with values closer to the center being swirled less)
/// and how through the transition is.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Parameter radius: How large the swirl should be relative to the view it's transitioning.
/// - Returns: The new pixel color.
[[stitchable]] half4 swirl(float2 position, SwiftUI::Layer layer, float2 size, float amount, float radius) {
    // Calculate our coordinate in UV space, -0.5 to 0.5.
    float2 uv = position / size;
    uv -= 0.5;

    // Calculate the distance from the center to the current point.
    float distanceFromCenter = length(uv);

    // Only apply the swirl effect within the specified radius.
    if (distanceFromCenter < radius) {
        // Calculate the swirl effect's strength based on distance from center.
        float swirlStrength = (radius - distanceFromCenter) / radius;

        // Determine the amount of swirl.
        // If amount is less than 0.5, interpolate from
        // 0 to 1; otherwise, interpolate from 1 back to 0.
        float swirlAmount;

        if (amount <= 0.5) {
            swirlAmount = mix(0, 1, amount / 0.5);
        } else {
            swirlAmount = mix(1, 0, (amount - 0.5) / 0.5);
        }

        // Calculate the swirl angle based on the swirl strength and amount.
        float swirlAngle = swirlStrength * swirlStrength * swirlAmount * 8 * M_PI;

        // Compute sine and cosine for the rotation.
        float sinAngle = sin(swirlAngle);
        float cosAngle = cos(swirlAngle);

        // Rotate the UV coordinates according to the swirl angle.
        uv = float2(dot(uv, float2(cosAngle, -sinAngle)), dot(uv, float2(sinAngle, cosAngle)));
    }

    // Move UVs back to the range 0...1.
    uv += 0.5;

    // Now blend the pixel at that location with the clear
    // color based on amount, so we fade out over time.
    return mix(layer.sample(uv * size), 0, amount);
}
