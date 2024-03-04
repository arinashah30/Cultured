//
//  StartWordGuessingView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct StartWordGuessingView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("WordGuessing")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 470)
                
                Button {
                    
                } label: {
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .padding(.top, 50)
                            .padding(.leading, 20)
                            .foregroundColor(Color.white.opacity(0.8))
                        Image("Arrow")
                            .padding(.top, 50)
                            .padding(.leading, 18)
                    }
                    
                }
                
            }
            
            ZStack (alignment: .topLeading){
                Rectangle()
                    .frame(width: 400, height: 460)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.white)
                VStack (alignment: .leading){
                    Text("Word Guessing")
                        .foregroundColor(.cDarkGray)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("India")
                        .foregroundColor(.cMedGray)
                    Text("Select Category")
                        .font(Font.custom("Quicksand-Medium", size: 20))
                        .foregroundColor(.cDarkGray)
                        .padding(.top, 20)
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20) {
                        Button {
                            
                        } label: {
                            Text("Pop Culture")
                                .font(.system(size: 20))
                                .foregroundColor(.cDarkGray)
                                .padding()
                        }
                        .frame(maxWidth: 154, maxHeight: 57)
                        .background(Color.cRed)
                        .clipShape(.rect(cornerRadius: 14.0))
                        
                        Button {
                            
                        } label: {
                            Text("Food")
                                .font(.system(size: 20))
                                .foregroundColor(.cDarkGray)
                                .padding()
                        }
                        .frame(maxWidth: 154, maxHeight: 57)
                        .background(Color.cOrange)
                        .clipShape(.rect(cornerRadius: 14.0))
                    }
                    .shadow(radius: 4, x: 0, y: 2)
                    
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20) {
                        Button {
                            
                        } label: {
                            Text("Customs")
                                .font(.system(size: 20))
                                .foregroundColor(.cDarkGray)
                                .padding()
                        }
                        .frame(maxWidth: 154, maxHeight: 57)
                        .background(Color("Category3"))
                        .clipShape(.rect(cornerRadius: 14.0))
                        .padding(.top, 15)
                        
                        Button {
                            
                        } label: {
                            Text("Drink")
                                .font(.system(size: 20))
                                .foregroundColor(.cDarkGray)
                                .padding()
                        }
                        .frame(maxWidth: 154, maxHeight: 57)
                        .background(Color("Category4"))
                        .clipShape(.rect(cornerRadius: 14.0))
                        .padding(.top, 15)
                    }
                    .shadow(radius: 4, x: 0, y: 2)
                    
                    Button {
                        
                    } label: {
                        Text("Start")
                            .font(.system(size: 20))
                            .foregroundColor(.cDarkGray)
                            .padding()
                    }
                    .frame(maxWidth: 154, maxHeight: 57, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.black.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 100.0))
                    .padding(.top, 15)
                    .padding(.leading, 85)
                }
                
                .padding(.top, 30)
                .padding(.leading, 35)
            }
        }
    }
}

#Preview {
    StartWordGuessingView(vm: ViewModel())
}
