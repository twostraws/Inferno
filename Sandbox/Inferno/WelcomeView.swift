//
// WelcomeView.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// An initial view to give an overview of the sandbox, plus links to more information.
struct WelcomeView: View {
    /// Tracks whether the user is currently hovering over the Hacking with Swift logo.
    @State private var logoHover = false

    var body: some View {
        ViewThatFits(in: .vertical) {
            content

            /*
             If the content's ideal size does not fit vertically, then allow the content to scroll.
             This is useful when adapting to Dynamic Type changes.
             */
            ScrollView {
                content
            }
        }
        .navigationSubtitle("Welcome to the Shader Sandbox")
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 10) {
            Image(.logo)
                .padding(.bottom, 10)

            Link("github.com/twostraws/inferno", destination: URL(string: "https://github.com/twostraws/inferno")!)
                .font(.title2.bold())

            Text("This is a small sandbox so you can see the various shaders in action. To use the shaders in your own code, follow the instructions in the documentation rather than taking code from here.")
                .multilineTextAlignment(.center)
                .font(.title3)

            Spacer()
            Spacer()

            Link(destination: URL(string: "https://www.hackingwithswift.com")!) {
                VStack {
                    Image(.HWS)
                        .renderingMode(logoHover ? .template : .original)
                    Text("A Hacking with Swift Project")
                }
            }
            .onHover { logoHover = $0 }
            .foregroundStyle(.white)
        }
        .padding()
    }
}
