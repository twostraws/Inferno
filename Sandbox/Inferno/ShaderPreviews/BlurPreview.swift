//
//  BlurPreview.swift
//  Inferno
//
//  Created by Dale Price on 11/28/23.
//

import SwiftUI

/// A SwiftUI view that displays a specific blur effect preview.
struct BlurPreview: View {
    /// The opacity of the preview view.
    @State private var opacity = 1.0
    
    /// The effect to render.
    var effect: BlurEffect
    
    var body: some View {
        Group {
            switch effect.effect {
            case .progressiveBlur:
                ProgressiveBlurPreview(opacity: $opacity)
            case .shape(let shape):
                ShapeBlurPreview(opacity: $opacity, shape: shape)
            }
        }
        .toolbar {
            ToggleAlphaButton(opacity: $opacity)
        }
        .navigationSubtitle(effect.name)
    }
}

#Preview {
    BlurPreview(effect: BlurEffect.effects[0])
}
