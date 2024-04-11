//
//  MajorCitiesView.swift
//  Cultured
//
//  Created by Michelle Lee on 3/7/24.
//

import SwiftUI

struct MajorCitiesView: View {
    var body : some View {
        NavigationView {
            VStack {
                ZStack (alignment: .topLeading){
                    Image("MajorCities")
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
                            Text("Major Cities")
                                .foregroundColor(.cDarkGray)
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .padding(.top, 20)
                            Text("Mexico") //getCountryName()
                                .foregroundColor(.cMedGray)
                            //list of cities
                            //for (int i = 0; i < list.length; i++) {
                            //if (i % 2 == 0) {
                            HStack (alignment: .top){
                                VStack {
                                    Image("MapPointer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 26, height: 33)
                                    Text("San Miguel De Allende") //getCityName()
                                        .font(Font.custom("Quicksand-Medium", size: 20))
                                        .foregroundColor(.cDarkGray)
                                        .padding(.bottom, 5)
                                    Text("In this vibrant city, do this and this activity. this this") //getCityDescription()
                                        .foregroundColor(.cMedGray)
                                }
                                .padding(.top, 10)
                                Image("SanMiguel")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                                    .padding(.leading, 20)
                            }
                            .padding(.bottom, 20)
                            //else {
                            HStack (alignment: .top){
                                Image("SanMiguel")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                                    .padding(.leading, 10)
                                VStack {
                                    Image("MapPointer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 26, height: 33)
                                    Text("San Miguel De Allende")
                                        .font(Font.custom("Quicksand-Medium", size: 20))
                                        .foregroundColor(.cDarkGray)
                                        .padding(.bottom, 5)
                                    Text("In this vibrant city, do this and this activity.")
                                        .foregroundColor(.cMedGray)
                                }
                                .padding(.top, 10)
                            }
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
    MajorCitiesView()
}
