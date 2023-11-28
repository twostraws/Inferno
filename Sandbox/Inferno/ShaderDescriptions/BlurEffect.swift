//
//  BlurShader.swift
//  Inferno
//
//  Created by Dale Price on 11/28/23.
//

import SwiftUI

/// An effect based on a blur shader that specifies the effect to use.
struct BlurEffect: Hashable, Identifiable {
    
    /// Specifies the type of blur effect to apply. These all use the same shader but draw a different mask using SwiftUI's `GraphicsContext`.
    enum EffectType {
        /// A blur masked with a linear gradient.
        case progressiveBlur
        
        /// A blur masked with a shape.
        case shape(any Shape)
    }
    
    // Unique, random identifier for this effect.
    var id = UUID()
    
    /// The human readable name for this effect.
    var name: String
    
    /// The type of blur effect to use.
    var effect: EffectType
    
    /// Custom Equatable conformance.
    static func ==(lhs: BlurEffect, rhs: BlurEffect) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Custom Hashable conformance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// All the blur effects we want to show.
    static let effects: [BlurEffect] = [
        BlurEffect(name: "Progressive Blur", effect: .progressiveBlur),
        BlurEffect(name: "Vignette", effect: .shape(Ellipse())),
        BlurEffect(name: "Rounded Rectangle Mask", effect: .shape(RoundedRectangle(cornerRadius: 25.0)))
    ]
}
