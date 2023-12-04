//
//  Genie.metal
//  Inferno
//
//  Created by Zachary Gorak on 12/2/23.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float2 remap(float2 uv, float2 inputLow, float2 inputHigh, float2 outputLow, float2 outputHigh){
    float2 t = (uv - inputLow)/(inputHigh - inputLow);
    float2 final = mix(outputLow,outputHigh,t);
    return final;
}

[[ stitchable ]] float2 genieTranstion(float2 position, float2 size, float effectValue) {
    // Normalized pixel coordinates (from 0 to 1)
    //float2 uv = float2(position.x*effectValue, position.y*effectValue);

    float2 normalizedPosition = position / size;
    float positiveEffect = effectValue*sign(effectValue);
    float progress = abs(sin(positiveEffect * M_PI_2_F));

    float bias = pow((sin(normalizedPosition.y * M_PI_F) * 0.1), 0.9);

    // right side
    float BOTTOM_POS = size.x;
    // width of the mini frame
    float BOTTOM_THICKNESS = 0.1;
    // height of the min frame
    float MINI_FRAME_THICKNESS = 0.0;
    // top left
    // float2 MINI_FRAME_POS = float2(0.0, 0.0)
    // top right
    float2 MINI_FRAME_POS = float2(size.x, 0.0);
    // bottom right
    //float2 MINI_FRAME_POS = size;

//    float min_x_curve = mix(progress, 0.0, normalizedPosition.y);
//    float max_x_curve = mix(-progress, 1.0, normalizedPosition.y);
//    float min_x = mix(min_x_curve, 0.0, progress);
//    float max_x = mix(max_x_curve, 1.0, progress);
    float min_x_curve = mix((BOTTOM_POS-BOTTOM_THICKNESS/2.0)+bias, 0.0, normalizedPosition.y);
    float max_x_curve = mix((BOTTOM_POS+BOTTOM_THICKNESS/2.0)-bias, 1.0, normalizedPosition.y);
    float min_x = mix(min_x_curve, MINI_FRAME_POS.x, progress);
    float max_x = mix(max_x_curve, MINI_FRAME_POS.x+MINI_FRAME_THICKNESS, progress);

    //float min_y = 0;
   // float min_y = mix(0.0,0.1,progress);
    //float max_y = 1.0;
    //float max_y = mix(1.0,0.2,progress);

    float min_y = mix(0.0, MINI_FRAME_POS.y, progress);
    float max_y = mix(1.0, MINI_FRAME_POS.y+MINI_FRAME_THICKNESS, progress);

    float2 modUV = remap(position, float2(min_x, min_y), float2(max_x, max_y), float2(0.0), float2(1.0));

    float2 final = mix(position, modUV, progress);

//    if (final.y > 1.0) {
//        final.y = 1.0;
//    }
//    if (final.x > 1.0) {
//        final.x = 1.0;
//    }

    return position + modUV * progress;

    //return final;

    //return clamp(final, float2(0.0), size);

    //return mix(position,normalizedPosition,-progress);

//
//    float2 uv = position;
//    float f = abs(2.0);
//
//    float t = uv.y;
//    float bias = sin(effectValue*M_PI_F)*0.1;
//    bias = pow(bias,0.9);
//
//    float BOTTOM_POS = 0.25;
//    float BOTTOM_THICKNESS = 0.1;
//    float MINI_FRAME_THICKNESS = 0.1;
//    float2 MINI_FRAME_POS = float2(0.1,0.1);
//
//    float min_x_curve = mix((BOTTOM_POS-BOTTOM_THICKNESS/2.0)+bias,0.0,t);
//    float max_x_curve = mix((BOTTOM_POS+BOTTOM_THICKNESS/2.0)-bias,1.0,t);
//    float min_x = mix(min_x_curve,MINI_FRAME_POS.x,f);
//    float max_x = mix(max_x_curve,MINI_FRAME_POS.x+MINI_FRAME_THICKNESS,f);
//    float min_y = mix(0.0,MINI_FRAME_POS.y,f);
//    float max_y = mix(1.0,MINI_FRAME_POS.y+MINI_FRAME_THICKNESS,f);
//    //float min_y = 0.0;
//    //float max_y = f;
//    float2 modUV = remap(uv, float2(min_x,min_y), float2(max_x,max_y), float2(0.0), float2(1.0));
//    float2 finalUV = mix(uv,modUV,1.0*f);
//
//    return finalUV;

//    float3 tex = float3(0.0);
//    tex = finalUV.x>1.0||finalUV.x<0.0?float3(0.0):tex;
//    tex = finalUV.y>1.0||finalUV.y<0.0?float3(0.0):tex;
//    // Time varying pixel color
//    float3 col = tex;
//
//    float shift = effectValue*size.x;
//    // Output to screen
//    float2 newPos = float2(position.x + shift, position.y + shift);
//
//    return float2(position.x + shift, position.y + shift);
}
