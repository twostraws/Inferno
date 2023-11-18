//
//  PlatformShims.swift
//  Inferno
//
//  Created by Paul Hudson on 18/11/2023.
//

import SwiftUI

#if !os(macOS)
extension View {
    func navigationSubtitle(_ text: String) -> some View {
        self
    }
}
#endif
