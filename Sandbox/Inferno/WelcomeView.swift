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
        VStack(spacing: 10) {
            Spacer()

            Image(.logo)
                .padding(.bottom, 10)

            Link("github.com/twostraws/inferno", destination: URL(string: "https://github.com/twostraws/inferno")!)
                .font(.title.bold())

            Text("This is a small sandbox so you can see the various shaders in action. To use the shaders in your own code, follow the instructions in the documentation rather than taking code from here – this project contains a lot of extra code to handle previewing, most of which isn't required in other projects.")
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
        #if !os(visionOS)
        .navigationSubtitle("Welcome to the Shader Sandbox")
        #endif
        .padding()
    }
}
