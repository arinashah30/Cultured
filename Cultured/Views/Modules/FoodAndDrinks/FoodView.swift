//
//  FoodView.swift
//  Cultured
//
//  Created by Gustavo Garfias on 02/04/24.
//

import SwiftUI

struct FoodView: View {
    @ObservedObject var vm: ViewModel
    
    enum SelectedCategory: String, CaseIterable {
        case Popular, Seasonal, Regional
    }
    
    @State var selectedCategory: SelectedCategory = .Popular
    
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
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                        .clipShape(.rect(cornerRadius: 40))
                        .foregroundColor(.white)
                    
                    ScrollView(.vertical) {
                        VStack (alignment: .leading){
                            Text("Food")
                                .foregroundColor(Color(red: 0.97, green: 0.25, blue: 0.25))
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                            Text("Mexico")
                                .foregroundColor(.cMedGray)
                            
                            HStack(alignment: .top) {
                                ForEach(SelectedCategory.allCases, id: \.rawValue) { cat in
                                    Button {
                                        selectedCategory = cat
                                    } label: {
                                        VStack {
                                            Text(cat.rawValue)
                                                .font(Font.custom("Quicksand-Medium", size: 18))
                                            
                                            if selectedCategory == cat {
                                                Divider()
                                                    .frame(width: 50, height: 2)
                                                    .overlay(Color(red: 0.97, green: 0.25, blue: 0.25))
                                            }
                                        }
                                        .padding()
                                        .foregroundColor(selectedCategory == cat ? Color(red: 0.97, green: 0.25, blue: 0.25) : .cDarkGray)
                                    }
                                }
                            }
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    VStack {
                                        Image("Horchata")
                                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                        Text("Horchata")
                                    }
                                    
                                    VStack {
                                        Image("Mangonada")
                                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                        Text("Mangonada")
                                    }
                                    
                                    VStack {
                                        Image("Horchata")
                                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                        Text("Horchata")
                                    }
                                    
                                    VStack {
                                        Image("Mangonada")
                                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                        Text("Mangonada")
                                    }
                                }
                                .padding(.bottom, 20)
                            }
                            
                            Text("All Items")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundColor(.cDarkGray)
                                .padding(.top, 20)
                            
                            VStack(alignment: .leading) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14.0)
                                        .frame(width: 0.8 * UIScreen.main.bounds.width)
                                        .foregroundColor(.cLightGray)
                                    HStack {
                                        Image("Drink")
                                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                        VStack(alignment: .leading) {
                                            Text("Food Item")
                                                .font(.system(size: 20))
                                            Text("Short description of item.")
                                                .font(.system(size: 16))
                                                .foregroundColor(.cDarkGray)
                                        }
                                        .padding(.leading, 10)
                                    }
                                    .padding(.vertical)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14.0)
                                        .frame(width: 0.8 * UIScreen.main.bounds.width)
                                        .foregroundColor(.cLightGray)
                                    HStack {
                                        Image("Drink")
                                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                        VStack(alignment: .leading) {
                                            Text("Food Item")
                                                .font(.system(size: 20))
                                            Text("Short description of item.")
                                                .font(.system(size: 16))
                                                .foregroundColor(.cDarkGray)
                                        }
                                        .padding(.leading, 10)
                                    }
                                    .padding(.vertical)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14.0)
                                        .frame(width: 0.8 * UIScreen.main.bounds.width)
                                        .foregroundColor(.cLightGray)
                                    HStack {
                                        Image("Drink")
                                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                        VStack(alignment: .leading) {
                                            Text("Food Item")
                                                .font(.system(size: 20))
                                            Text("Short description of item.")
                                                .font(.system(size: 16))
                                                .foregroundColor(.cDarkGray)
                                        }
                                        .padding(.leading, 10)
                                    }
                                    .padding(.vertical)
                                }
                            }
                            .padding(.bottom, 40)
                            
                        }
                        
                    }
                    .padding(.top, 30)
                    .padding(.leading, 32)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                }
                .padding(.leading, 7)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    FoodView(vm: ViewModel())
}
