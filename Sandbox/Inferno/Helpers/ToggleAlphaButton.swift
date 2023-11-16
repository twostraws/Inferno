//
// ToggleAlphaButton.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

struct ToggleAlphaButton: View {
    @Binding var opacity: Double

    var body: some View {
        Button("Toggle Opacity", systemImage: "cube.transparent") {
            withAnimation {
                if opacity.isZero {
                    opacity = 1
                } else {
                    opacity = 0
                }
            }
        }
        .labelStyle(.titleAndIcon)
    }
}

#Preview {
    ToggleAlphaButton(opacity: .constant(1))
}
