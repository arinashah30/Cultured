//
//  ProgressButtonView.swift
//  Cultured
//
//  Created by Shreyas Goyal on 4/4/24.
//

import SwiftUI

struct ProgressButtonView: View {
    @State var buttonText: String
    @State var buttonColor: Color
    @Binding var progress: Float
    //let action: () -> Void
    
    private func clampProgress(progress: Float) -> Float {
        return min(max(progress, 0.0), 1.0)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 14.0)
                .frame(maxWidth: (CGFloat)(154 * clampProgress(progress: progress)), maxHeight: 57)
            .foregroundColor(buttonColor)
            .padding(.top, 15)
            
            //Button(action: {
            //    action() // Call the action closure when the button is tapped
            //}) {
                Text(buttonText)
                    .font(.system(size: 20))
                    .foregroundColor(.cDarkGrayConstant)
                    .padding()
            //}
            .frame(maxWidth: 154, maxHeight: 57)
            .background(buttonColor.opacity(0.4))
            .clipShape(.rect(cornerRadius: 14.0))
            .padding(.top, 15)
        }
    }
}

//#Preview {
//    ProgressButtonView(buttonText: "Button", buttonColor: Color("Category3"), progress: 0.4)
//}
