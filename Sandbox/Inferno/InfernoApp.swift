//
// InfernoApp.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI


@main
/// The main entry point for the sandbox app.
struct InfernoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if !os(visionOS)
                .frame(minWidth: 800, minHeight: 600)
                #else
                .frame(minWidth: 1000, minHeight: 800)
                #endif
        }
        #if !os(visionOS)
        .defaultSize(width: 800, height: 600)
        #else
        .defaultSize(width: 1000, height: 800)
        #endif
    }
}
