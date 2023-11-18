//
// TransitionPreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// A view that lets users see what a given transition looks like,
/// by flipping between two sample views.
struct TransitionPreview: View {
    /// Whether we're showing the first view or the second view.
    @State private var showingFirstView = true

    /// The opacity of our preview view, so users can check how fading works.
    @State private var opacity = 1.0

    /// The shader we're rendering.
    var shader: TransitionShader

    var body: some View {
        VStack {
            if showingFirstView {
                Image(systemName: "figure.walk.circle")
                    .font(.system(size: 300))
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .opacity(opacity)
                    .drawingGroup()
                    .transition(shader.transition)
            } else {
                Image(systemName: "figure.run.circle")
                    .font(.system(size: 300))
                    .foregroundStyle(.white)
                    .padding()
                    .background(.indigo)
                    .opacity(opacity)
                    .drawingGroup()
                    .transition(shader.transition)
            }

            Button("Toggle Views") {
                withAnimation(.easeIn(duration: 1.5)) {
                    showingFirstView.toggle()
                }
            }
        }
        .toolbar {
            ToggleAlphaButton(opacity: $opacity)
        }
        .navigationSubtitle(shader.name)
    }
}

#Preview {
    TransitionPreview(shader: .example)
}
