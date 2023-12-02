//
//  Distortion.metal
//  Inferno
//
//  Created by Zachary Gorak on 12/2/23.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


[[ stitchable ]] float2 shiftTranstion(float2 position, float2 size, float effectValue) {
    float skewF = 0.1*size.x;
    float yRatio = position.y/size.y;

    float positiveEffect = effectValue*sign(effectValue);
    float skewProgress = min(0.5-abs(positiveEffect-0.5), 0.2)/0.2;

    float skew = effectValue>0 ? yRatio*skewF*skewProgress : (1-yRatio)*skewF*skewProgress;
    float shift = effectValue*size.x;

    return float2(position.x+(shift+skew*sign(effectValue)), position.y);
}
