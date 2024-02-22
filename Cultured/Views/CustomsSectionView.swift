//
//  CustomsView.swift
//  Cultured
//
//  Created by Rethika Ambalam on 2/20/24.
//

import SwiftUI

struct CustomsSectionView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("Customs")
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
                    .frame(width: 395, height: 380)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.white)
                VStack (alignment: .leading){
                    Text("Customs")
                        .foregroundColor(.black)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("Mexico")
                        .foregroundColor(.cMedGray)
                    Text("Categories")
                        .font(Font.custom("Quicksand", size: 24))
                        .padding(.top, 20)
                    HStack {
                        Button {
                            
                        } label: {
                            Text("Tradition")
                                .font(Font.custom("Quicksand", size: 20))
                                .foregroundStyle(.black)
                                .padding()
                        }
                        .frame(maxWidth: 159, maxHeight: 57)
                        .background(Color.cRed)
                        .clipShape(.rect(cornerRadius: 14.0))
                        
                        Button {
                            
                        } label: {
                            Text("Holiday")
                                .font(Font.custom("Quicksand", size: 20))
                                .foregroundStyle(.black)
                                .padding()
                        }
                        .frame(maxWidth: 159, maxHeight: 57)
                        .background(Color.cOrange)
                        .clipShape(.rect(cornerRadius: 14.0))
                    }
                    .shadow(radius: 4, x: 0, y: 4)

                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text("Etiquette")
                                .font(Font.custom("Quicksand", size: 20))
                                .foregroundStyle(.black)
                                .padding()
                        }
                        .frame(maxWidth: 159, maxHeight: 57)
                        .background(Color.cGreen)
                        .clipShape(.rect(cornerRadius: 14.0))
                    }
                    .shadow(radius: 4, x: 0, y: 4)
                }
                .padding(.top, 30)
                .padding(.leading, 35)
            }
        }
    }
}

#Preview {
    CustomsSectionView(vm: ViewModel())
}


