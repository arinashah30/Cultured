//
//  FoodView.swift
//  Cultured
//
//  Created by Gustavo Garfias on 02/04/24.
//

import SwiftUI


struct TraditionsView: View {
    @ObservedObject var vm: ViewModel
    @State private var selection = Category.Spring

    private enum Category: Hashable {
        case Spring
        case Summer
        case Fall
        case Winter
    }
    
    public var traditionsRed: Color {
        Color(red:247/255, green:64/255, blue:64/255)
    }
    
    
    var body: some View {
        ZStack (alignment: .topLeading){
            Image("Traditions")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth, height: screenHeight * 0.5)
                .ignoresSafeArea()
                .offset(y:-65)
            
            BackButton()
            
            VStack{
                Spacer()
                ZStack (alignment: .topLeading){
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                        .clipShape(.rect(cornerRadius: 40))
                        .foregroundColor(.white)
                        .offset(x:-3)
                    

                        VStack (alignment: .leading){
                            Text("Traditions")
                                .foregroundColor(Color(red: 0.97, green: 0.25, blue: 0.25))
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .padding(.leading, 32)

                            Text("Mexico")
                                .foregroundColor(.cMedGray)
                                .padding(.leading, 32)
                            
                            
                            HStack {
                                Spacer()
                                Button {
                                    selection = .Spring
                                } label: {
                                    if selection == .Spring {
                                        Text("Spring")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(traditionsRed)
                                            .underline()
                                    } else {
                                        Text("Spring")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(.cMedGray)
                                    }
                                }
                                
                                Button {
                                    selection = .Summer
                                } label: {
                                    if selection == .Summer {
                                        Text("Summer")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(traditionsRed)
                                            .underline()
                                            .padding(.leading, 23)
                                    } else {
                                        Text("Summer")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(.cMedGray)
                                            .padding(.leading, 23)
                                    }
                                }
                                Button {
                                    selection = .Fall
                                } label: {
                                    if selection == .Fall {
                                        Text("Fall")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(traditionsRed)
                                            .underline()
                                            .padding(.leading, 23)
                                    } else {
                                        Text("Fall")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(.cMedGray)
                                            .padding(.leading, 23)
                                    }
                                }
                                
                                Button {
                                    selection = .Winter
                                } label: {
                                    if selection == .Winter {
                                        Text("Winter")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(traditionsRed)
                                            .underline()
                                            .padding(.leading, 23)
                                    } else {
                                        Text("Winter")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(.cMedGray)
                                            .padding(.leading, 23)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 15)
                            .padding(.top,1)
 
                                ScrollView(.vertical) {
                                    VStack(alignment:.leading){
                                    switch selection {
                                    case .Spring:
                                        TraditionsSpringView()
                                    case .Summer:
                                        TraditionsSpringView()
                                    case .Fall:
                                        TraditionsSpringView()
                                    case .Winter:
                                        TraditionsSpringView()
                                    }
                                }
                            }
                                .padding(.bottom, 30)
                        
                    }
                    .padding(.top, 30)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                    .scrollIndicators(.hidden)
                }
                .padding(.leading, 7)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .ignoresSafeArea()
    }
}

struct TraditionsSpringView: View {
    var body: some View {
        VStack(alignment: .center) {
            
            HStack {
                Spacer()
                HStack {
                    Image("Drink")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenHeight * 0.1, height: screenHeight * 0.1)
                        .cornerRadius(20)
                    VStack(alignment: .leading) {
                        Text("Food Item")
                            .font(.system(size: 20))
                        Text("Short description of item.")
                            .font(.system(size: 16))
                            .foregroundColor(.cDarkGray)
                    }
                    .frame(width: screenWidth * 0.6)
//                    .background(.blue)
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 1/9)
                .background(Color.cLightGray)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Spacer()
            }
            
            HStack {
                Spacer()
                HStack {
                    Image("Drink")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenHeight * 0.1, height: screenHeight * 0.1)
                    //                                            .clipShape(RoundedRectangle(cornerRadius:20.0))
                        .cornerRadius(20)
                    VStack(alignment: .leading) {
                        Text("Food Item")
                            .font(.system(size: 20))
                        Text("Short description of item.")
                            .font(.system(size: 16))
                            .foregroundColor(.cDarkGray)
                    }
                    .frame(width: screenWidth * 0.6)
                    //                                        .padding(.leading, 10)
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 1/9)
                .background(Color.cLightGray)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Spacer()
            }
            
            HStack {
                Spacer()
                HStack {
                    Image("Drink")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenHeight * 0.1, height: screenHeight * 0.1)
                    //                                            .clipShape(RoundedRectangle(cornerRadius:20.0))
                        .cornerRadius(20)
                    VStack(alignment: .leading) {
                        Text("Food Item")
                            .font(.system(size: 20))
                        Text("Short description of item.")
                            .font(.system(size: 16))
                            .foregroundColor(.cDarkGray)
                    }
                    .frame(width: screenWidth * 0.6)
                    //                                        .padding(.leading, 10)
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 1/9)
                .background(Color.cLightGray)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Spacer()
            }
        }
    }
}



#Preview {
    TraditionsView(vm: ViewModel())
}
