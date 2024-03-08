//
//  MajorCitiesView.swift
//  Cultured
//
//  Created by Michelle Lee on 3/7/24.
//

import SwiftUI

struct MajorCitiesView: View {
    var body : some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("MajorCities")
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
                    Text("Major Cities")
                        .foregroundColor(.cDarkGray)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("Mexico")
                        .foregroundColor(.cMedGray)
                    //ForEach (array of regions) { region in Text(region) }
                    Text("North Mexico")
                        .font(Font.custom("Quicksand-Medium", size: 24))
                        .foregroundColor(.cDarkGray)
                        .padding(.top, 20)
                    HStack {
                        VStack {
                            Image("MapPointer")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 26, height: 33)
                            Text("San Miguel De Allende")
                                .font(Font.custom("Quicksand-Medium", size: 20))
                                .foregroundColor(.cDarkGray)
                                .padding(.top, 20)
                            Text("insert description of the major city, there are these many things to do and see.")
                                .foregroundColor(.cDarkGray)
                        }
                        Image("SanMiguel")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 180)
                    }
                }
            }
        }
    }
}

#Preview {
    MajorCitiesView()
}
