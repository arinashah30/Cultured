//
//  StartConnectionsView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct StartConnectionsView: View {
    @StateObject var vm: ConnectionsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategories: Set<String> = []
    let categories = ["Pop Culture", "Food", "Customs", "Places"]
    
    let buttonColors: [Color] = [Color(red: 252/255, green: 179/255, blue: 179/255), Color(red: 255/255, green: 219/255, blue: 165/255), Color(red: 171/255, green: 232/255, blue: 186/255), Color(red: 153/255, green: 194/255, blue: 223/255)]
    
    let buttonWidth: CGFloat = 156
    let buttonHeight: CGFloat = 57
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack (alignment: .topLeading){
                    Image("WordGuessing")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 470, alignment: .top)
                
                    
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .padding(.top, 150)
                                .padding(.leading, 20)
                                .foregroundColor(Color.white.opacity(0.8))
                            Image("Arrow")
                                .padding(.top, 150)
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
                        Text("Connections")
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
                        
                        NavigationLink(destination: {
                                        ConnectionsGameView(vm: ConnectionsViewModel())
                                    }, label: {
                                        Text("Start")
                                            .font(.system(size: 20))
                                            .foregroundColor(.cDarkGray)
                                            .padding()
                                    })
                        .frame(maxWidth: 154, maxHeight: 57, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.black.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 100.0))
                        .padding(.top, 15)
                        .padding(.leading, 85)
                        //.padding(.bottom, 200)
                    }
                    .padding(.top, 30)
                    .padding(.leading, 35)
                    //.frame(alignment: .center)
                }
            }
            .padding(.bottom, 200)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StartConnectionsView(vm: ConnectionsViewModel())
}
