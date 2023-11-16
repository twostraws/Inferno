//
// ContentPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// Provides three different preview options for shaders 
/// where that makes sense.
struct ContentPreview: View {
    @AppStorage("currentPreviewType") private var currentPreviewType = PreviewType.symbol
    
    // Note: No matter what, we ensure a 400x400
    // frame to avoid the view jumping around.
    var body: some View {
        switch currentPreviewType {
        case .emoji:
            Text("🏳️‍🌈")
                .frame(width: 400, height: 400)
                .font(.system(size: 300))
        case .image:
            Image(.doggo)
                .frame(width: 400, height: 400)
        case .shape:
            RoundedRectangle(cornerRadius: 40)
                .fill(.white)
                .frame(height: 400)
                .padding(.horizontal, 50)
        case .symbol:
            Image(systemName: "figure.walk.circle")
                .frame(width: 400, height: 400)
                .font(.system(size: 300))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentPreview()
}
