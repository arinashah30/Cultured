//
//  DanceView.swift
//  Cultured
//
//  Created by Rudra Amin on 3/30/24.
//

import SwiftUI

struct DanceView: View {
    var body: some View {
        ZStack {
            // the background image
            VStack{
                Image("Dance")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width:UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.width/3)
                    .offset(y:-UIScreen.main.bounds.width/2)
                //                .opacity(0.5)
            }
            
            VStack{
                
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.height / 3)
                    .offset(y: UIScreen.main.bounds.height / 7)
            }
            
            
            // the quiz
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Dance")
                        .font(Font.custom("Quicksand-semibold",size: 32))
                        .foregroundColor(Color.cDarkOrange)
                    
                    Text("Mexico")
                        .font(.system(size: 16))
                        .foregroundColor(
                            Color(red: 157/255, green: 157/255, blue: 157/255))
                    
                    
                    
                    Text("Traditional")
                        .padding(.vertical, 10)
                        .font(Font.custom("Quicksand-medium",size: 24))
                    
                    
                    VStack(spacing: 20) {
                        HStack (alignment: .top) {
                            Image("Dance").resizable().clipShape(RoundedRectangle(cornerRadius: 14)).frame(width: 145)
                            Spacer()
                            VStack (alignment: .leading, spacing: 0) {
                                Text("Mexican Hat Dance").font(Font.custom("Quicksand-medium",size: 24)).padding(.vertical, 10)
                                Text("Insert dance for appropriate seasonal celebration.").font(Font.custom("Quicksand-regular",size: 20))
                            }.padding(.trailing, 10)
                        }.frame(width: 321, height: 185).background(Color.cLightGray).clipShape(RoundedRectangle(cornerRadius: 14)).shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        HStack (alignment: .top) {
                            Image("OtherDance").resizable().clipShape(RoundedRectangle(cornerRadius: 14)).frame(width: 145)
                            Spacer()
                            VStack (alignment: .leading, spacing: 0) {
                                Text("Other Dance").font(Font.custom("Quicksand-medium",size: 24)).padding(.vertical, 10)
                                Text("Insert dance information here.").font(Font.custom("Quicksand-regular",size: 20))
                            }.padding(.trailing, 10)
                        }.frame(width: 321, height: 185).background(Color.cLightGray).clipShape(RoundedRectangle(cornerRadius: 14)).shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    
                    
                }
            }.offset(y:UIScreen.main.bounds.height/7).padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            
        }
        .navigationBarBackButtonHidden()
        .padding(.bottom, 100)
        
    }
}



#Preview {
    DanceView()
}
