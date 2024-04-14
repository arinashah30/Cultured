//
//  SectionView.swift
//  Cultured
//
//  Created by Rethika Ambalam on 2/13/24.
//

import SwiftUI

struct PopCultureSectionView: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment:.topLeading){
                Image("PopCulture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 470)
                
                BackButton()
                
                VStack {
                    Spacer()
                    ZStack (alignment: .topLeading){
                        Rectangle()
                            .frame(width: 395, height: 405)
                            .clipShape(.rect(cornerRadius: 40))
                            .foregroundColor(.white)
                        VStack (alignment: .leading){
                            Text("Pop Culture")
                                .foregroundColor(.cDarkGray)
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                            Text("Mexico")
                                .foregroundColor(.cMedGray)
                            Text("Categories")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundColor(.cDarkGray)
                                .padding(.top, 20)
                            HStack (spacing: 13) {
                                NavigationLink {
                                    MusicView(vm: vm)
                                        .navigationBarBackButtonHidden(true)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Text("Music")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGray)
                                        .padding()
                                }
                                .frame(maxWidth: 159, maxHeight: 57)
                                .background(Color.cRed)
                                .clipShape(.rect(cornerRadius: 14.0))
                                
                                
                                NavigationLink {
                                    DanceView(vm: vm)
                                        .navigationBarBackButtonHidden(true)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Text("Dance")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGray)
                                        .padding()
                                }
                                .frame(maxWidth: 159, maxHeight: 57)
                                .background(Color.cOrange)
                                .clipShape(.rect(cornerRadius: 14.0))
                            }
                            .shadow(radius: 4, x: 0, y: 4)
                            .padding(.bottom, 8)
                            
                            HStack (spacing: 13){
                                Button {
                                    
                                } label: {
                                    Text("Sports")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGray)
                                        .padding()
                                }
                                .frame(maxWidth: 159, maxHeight: 57)
                                .background(Color.cGreen)
                                .clipShape(.rect(cornerRadius: 14.0))
                                
                                NavigationLink(destination: MovieView(), label: {
                                    Text("Movies/TV")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGray)
                                        .padding()
                                }).frame(maxWidth: 159, maxHeight: 57)
                                    .background(Color.cBlue)
                                    .clipShape(.rect(cornerRadius: 14.0))
                       
                                
                            }
                            .shadow(radius: 4, x: 0, y: 4)
                            HStack {
                                Spacer()
                                Button {} label: {
                                    Text("Quiz Me!")
                                        .foregroundColor(.cMedGray)
                                        .font(.system(size: 20))
                                }
                                Spacer()
                            }
                            .padding(.top, 30)
                            .padding(.leading, -35)
                        }
                        .padding(.top, 30)
                        .padding(.leading, 32)
                    }
                }
                .padding(.leading, 2)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    PopCultureSectionView(vm: ViewModel())
}

