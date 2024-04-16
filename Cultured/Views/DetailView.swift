//
//  DetailView.swift
//  Cultured
//
//  Created by Arina Shah on 4/15/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var image: String
    @Binding var title: String
    @Binding var description: String
    //var color: Color = Color.cBar
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 10) // Adjust corner radius as needed
                .fill(Color.cPopover) // Set the fill color of the rounded rectangle
            
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(color, lineWidth: 5) // Set border color and width
//                )
                .frame(width: 304, height: 550)
            
            VStack(alignment: .center) {
                Image(image).resizable().frame(width: 304, height: 100).scaledToFill().clipShape(RoundedRectangle(cornerRadius: 10))
                Text(title).font(Font.custom("Quicksand-Bold", size: 35)).multilineTextAlignment(.center).padding().background(Color.cPopover)
                Text(description).padding().font(Font.custom("Quicksand-Medium", size: 25)).minimumScaleFactor(0.3)
                Spacer()
            }.frame(width: 304, height: 550)
        }
    }
}

//#Preview {
//    DetailView(title: "Title", description: "Description")
//}
