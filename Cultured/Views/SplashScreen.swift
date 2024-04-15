//
//  SplashScreen.swift
//  Cultured
//
//  Created by Austin Huguenard on 4/14/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("splashpage")
            .resizable() // Make the image resizable
            .aspectRatio(contentMode: .fill) // Fill the screen, maintaining aspect ratio
            .ignoresSafeArea()
    }
}

//#Preview {
//    SplashScreen()
//}
