//
//  MovieView.swift
//  Cultured
//
//  Created by Datta Kansal on 3/29/24.
//

import SwiftUI

struct MovieView: View {
    @State var actors = [Actor]()
    
    var body: some View {
        ZStack() {
            VStack() {
                Image("MovieBg")
                    .resizable()
                    .frame(width: 545, height: 313)
                
                    
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.67)
            }
            
            VStack() {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.39)
                ScrollView(.vertical) {
                    Text("Movies/TV")
                        .frame(maxWidth:350, alignment: .leading)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                        .foregroundColor(Color(red: 0.07450980, green: 0.5686274509803921, blue: 0.9176470588235294))
                    Text("Country")
                        .frame(maxWidth: 350, alignment: .leading)
                        .font(Font.custom("Sf-pro-display", size: 16))
                        .foregroundColor(Color(red: 148/255, green: 148/255, blue: 148/255))
                        
                    Spacer()
                        .frame(height: 30)
                    Text("Actor Spotlight")
                        .frame(maxWidth: 350, alignment: .leading)
                        .font(Font.custom("Quicksand-Mediium", size: 24))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    
                }
            }
        }
    }
}

#Preview {
    MovieView()
}
