//
// Emboss.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A shader that creates an embossing effect by adding brightness from pixels in one
/// direction, and subtracting brightness from pixels in the other direction.
///
/// This works in several steps. First, we create our base new color using the
/// pixel's existing color.

/// Second, we read values diagonally up and to the right, then down and to the
/// left, to see what's nearby, and add or subtract them from our color. How much
/// we add our subtract depends on the strength the user provided.

/// If you're not sure how this works, imagine a pixel on the top edge of a view.
/// Above it has nothing, so nothing gets added to the base color. Below it has a
/// pixel of the same color, so that color gets subtracted from the base color to
/// make it black. The same is true in reverse of pixels on the bottom edge: they
/// have nothing below so nothing is subtracted, but they have a pixel above so
/// that gets added, making it a bright color.
///
/// As for pixels in the middle, they'll get embossed based on the pixels either side
/// of them. If a red pixel is surrounded by a sea of other red pixels, then red will
/// get added from above then subtracted in equal measure from below, so the
/// final color will be the original.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter strength: How far we should we read pixels.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 emboss(float2 position, SwiftUI::Layer layer, float strength) {
    // Read the current pixel color.
    half4 currentColor = layer.sample(position);

    // Take a copy of that, so we can modify it safely.
    half4 newColor = currentColor;

    // Add an offset pixel, adding more of it based on strength
    newColor += layer.sample(position + 1.0) * strength;

    // Do the opposite in the other direction.
    newColor -= layer.sample(position - 1.0) * strength;

    // Send back the resulting color, factoring in the
    // original alpha to get smooth edges.
    return half4(newColor) * currentColor.a;
}
