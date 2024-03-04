//
//  ProgressBar.swift
//  Cultured
//
//  Created by Hannah Huang on 2/29/24.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat // current progress (0.0 to 1.0)
    var height: CGFloat  // height of the progress bar (19)
 

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(red:251/255, green: 220/255, blue:220/255))
                    .frame(height: height)

                Rectangle()
                    .foregroundColor(Color(red:241/255, green: 72/255, blue:72/255))
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.easeIn, value: progress)
            }
            .cornerRadius(height / 2)
        }
        .frame(height: height)
    }
}
