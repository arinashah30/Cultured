//
//  FoodCategorySectionView.swift
//  Cultured
//
//  Created by Rethika Ambalam on 2/20/24.
//

import SwiftUI

struct FoodCategorySectionView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        ZStack (alignment: .topLeading){
            Image("FoodCategory")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400, height: 470)
            
            BackButton()
            
            VStack{
                Spacer()
                ZStack (alignment: .topLeading){
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 350)
                        .clipShape(.rect(cornerRadius: 40))
                        .foregroundColor(.cPopover)
                    VStack (alignment: .leading){
                        Text("Food")
                            .foregroundColor(.cDarkGray)
                            .font(Font.custom("Quicksand-SemiBold", size: 32))
                        Text("Mexico")
                            .foregroundColor(.cMedGray)
                        Text("Categories")
                            .font(Font.custom("Quicksand-Medium", size: 24))
                            .foregroundColor(.cDarkGray)
                            .padding(.top, 20)
                        HStack {
                            Button {
                                
                            } label: {
                                Text("Food")
                                    .font(.system(size: 20))
                                    .foregroundColor(.cDarkGray)
                                    .padding()
                            }
                            .frame(maxWidth: 159, maxHeight: 57)
                            .background(Color.cRed)
                            .clipShape(.rect(cornerRadius: 14.0))
                            
                            Button {
                                
                            } label: {
                                Text("Drink")
                                    .font(.system(size: 20))
                                    .foregroundColor(.cDarkGray)
                                    .padding()
                            }
                            .frame(maxWidth: 159, maxHeight: 57)
                            .background(Color.cOrange)
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
                .padding(.leading, 7)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    FoodCategorySectionView(vm: ViewModel())
}

