//
//  TraditionsView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct TraditionsView: View {
    var body: some View {
        NavigationView {
            VStack {
                ZStack (alignment: .topLeading){
                    Image("Tradition")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 200)
                    
                    NavigationLink(destination: HomeView(vm: ViewModel(), points: 346, streak: 7, badges: 4)) {
                        
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .padding(.top, 20)
                                .padding(.leading, 20)
                                .foregroundColor(Color.white.opacity(0.8))
                            Image("Arrow")
                                .padding(.top, 20)
                                .padding(.leading, 18)
                        }
                    }
                    
                }
                ScrollView {
                    ZStack (alignment: .topLeading){
                        Rectangle()
                            .frame(width: 395, height: 600)
                            .clipShape(.rect(cornerRadius: 40))
                            .foregroundColor(.white)
                        VStack (alignment: .leading){
                            Text("Tradition")
                                .foregroundColor(.cDarkGray)
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .padding(.top, 20)
                            Text("Mexico") //getCountryName()
                                .foregroundColor(.cMedGray)
                            TabView {
                                Text("Fall content")
                                    .tabItem {
                                        //Image(systemName: "1.circle")
                                        Text("Fall")
                                    }
                                Text("Winter content")
                                    .tabItem {
                                        //Image(systemName: "1.circle")
                                        Text("Winter")
                                    }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    TraditionsView()
}
