//
// Pixellate.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// A transition that causes images to pixellate increasingly while fading out.
///
/// This is an effect that sounds simple, but has a lot of complexity to it.
///
/// First, we figure out where in the transition we currently are. The transition works
/// by making an image start fully visible and unpixellated, move to half visible
/// and fully pixellated, then move to being fully transparent and unpixellated. This
/// is calculated in the `direction` value.
///
/// Second, we perform quantization, which is a fancy way of saying we restrict
/// the number of values we're working with. We *could* pixellate this with a smooth
/// animation, and certainly that's possible when the `steps` parameter is 60 or greater.
/// However, for a more retro feel we can lower the animation speed so it moves more
/// jerkily – we restrict the range of animation frames from (eg) 60 down to 10.
///
/// Third, we figure out which pixel we're drawing. We were given the original position
/// as input, but in the pixellation effect we want to divide that by the square size
/// so we get chunky blocks of color,
///
/// Finally, we blend the pixel color with the transparent color as the
/// transition progresses, so it fades out.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter size: The size of the whole image, in user-space.
/// - Parameter amount: The progress of the transition, from 0 to 1.
/// - Parameter squares: How many pixel squares to generate.
/// - Parameter steps: How many animation steps we want to go through. Anything
///   above 60 or so is effectively smooth animation, whereas values such as 20 will
///   make a more jumpy animation.
/// - Returns: The new pixel color.
[[stitchable]] half4 pixellate(float2 position, SwiftUI::Layer layer, float2 size, float amount, float squares, float steps) {
    // Calculate our coordinate in UV space, 0 to 1.
    float2 uv = position / size;

    // Determine the direction of transition and restrict it
    // to the 0...1 range. This will count from 0.0 to 0.5,
    // then back down to to 0.0 again.
    float direction = min(amount, 1 - amount);

    // Quantize d to create a stepping effect. So, rather
    // than moving smoothly between states, we move in
    // discrete steps based on the number of steps specified
    // above. This causes a rougher transition, which works
    // great with the pixellation style.
    float steppedProgress = ceil(direction * steps) / steps;

    // Calculate the size of each square based on steppedProgress
    // and the minimum number of squares.
    float2 squareSize = 2 * steppedProgress / float2(squares);

    // If steppedProgress is greater than 0, adjust uv to be the
    // center of a square. Otherwise, use uv as is.
    float2 newPosition;

    // If our stepped progress is 0…
    if (steppedProgress == 0) {
        // Use the original pixel location, to avoid a divide by 0.
        newPosition = uv;
    } else {
        // Otherwise snap to the nearest point.
        newPosition = (floor(uv / squareSize) + 0.5) * squareSize;
    }

    // Now blend the pixel at that location with the clear
    // color based on transition progress, so we fade out
    // as we pixellate.
    return mix(layer.sample(newPosition * size), 0, amount);
}
