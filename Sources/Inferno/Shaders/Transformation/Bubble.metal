//
// WarpingLoupe.metal
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float specular(float3 eye, float3 normal, float3 light, float shininess, float diffuseness) {
    float3 lightVector = normalize(-light);
    float3 halfVector = normalize(eye + lightVector);
    
    float NdotL = dot(normal, lightVector);
    float NdotH =  dot(normal, halfVector);
    float NdotH2 = NdotH * NdotH;
    
    float kDiffuse = max(0.0, NdotL);
    float kSpecular = pow(NdotH2, shininess);
    
    return  kSpecular + kDiffuse * diffuseness;
}

/// A shader that creates a simplified soap bubble effect over a precise location.
///
/// This is a similar one to the loupe shaders, although this one renders a proper
/// sphere that models refraction and specular effect.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter layer: The SwiftUI layer we're reading from.
/// - Parameter uiSize: The size of the whole image, in user-space.
/// - Parameter uiPosition: The location the user is touching, where the bubble should be centered, in user-space.
/// - Parameter uiRadius: How large the bubble area should be, in user-space.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 bubble(
    float2 position,
    SwiftUI::Layer layer,
    float2 uiSize,
    float2 uiPosition,
    float uiRadius
) {
    // Calculate our coordinate in UV space, 0 to 1.
    const float2 uv = position / uiSize;
    
    // Calculate bubble radius in UV space.
    const float radius = uiRadius / min(uiSize.x, uiSize.y);
    
    // Figure out where the bubble center is in UV space.
    const float2 center = uiPosition / uiSize;
    
    // Calculate how far this pixel is from the center.
    const float2 positionToCenter = uv - center;
    
    // Figure out the distance from position to the center.
    const float distanceToCenter = length(positionToCenter);
    
    // If we're inside the bubble…
    if (distanceToCenter < radius) {
        // Calculate normals on a sphere of radius 1
        const float3 normal = normalize(
            float3(
                positionToCenter.x / radius,
                positionToCenter.y / radius,
                cos(M_PI_2_F * distanceToCenter / radius)
            )
        );
        
        // Look front facing to calculate refraction and specular
        const float3 eye = float3(0, 0, -5);
        
        // Use low index of refraction
        const float ior = 1.02;
        
        // Calculate refracted color
        const float3 refraction = refract(eye, normal, 1.0 / ior);
        const float2 refractedUV = uv - refraction.xy;
        half4 color = layer.sample(refractedUV * uiSize);
        
        // Add light reflection on the surface
        color += specular(normalize(eye), normal, float3(1, -1, -1), 100, .1);
        
        return color;
    }
    
    // Return sample outside of the bubble without change
    return layer.sample(float2(uv) * uiSize);
}
