//
//  ActivityView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        let lightOrange = Color(red: 255/255, green: 241/255, blue: 220/255, opacity: 1)
        ScrollView(.vertical) {
            VStack(alignment: .leading){
                Text("Activity")
                    .foregroundColor(.cDarkGray)
                    .font(Font.custom("Quicksand-SemiBold", size: 32))
                    .padding(.bottom, 10)
                Text("Badges")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                ZStack {
                    Rectangle()
                        .frame(width: 361, height: 188)
                        .foregroundColor(lightOrange)
                        .clipShape(.rect(cornerRadius: 14))
                        .padding(.bottom, 10)
                        .padding(.top, -14)
                    VStack(alignment: .leading) {
                        HStack {
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                                .padding(.leading, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                        }
                        .padding(.bottom, 18)
                        HStack {
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                                .padding(.leading, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                            Image("ShieldBadge")
                                .padding(.trailing, 15)
                            Image("ShieldBadge")
                        }
                        HStack (alignment: .bottom){
                            Button {
                            } label: {
                                Text("See More")
                                    .padding(.leading, 270)
                                    .padding(.top, 5)
                                    .font(Font.custom("Quicksand-Medium", size: 15))
                                    .foregroundColor(.cMedGray)
                            }
                        }
                    }
                    .padding(.top, -20)
                }
                
                Text("Streak")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 177, height: 188)
                            .clipShape(.rect(cornerRadius: 14))
                        VStack {
                            Text("Current Streak")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Image("Streak")
                                .resizable()
                                .frame(width: 60, height: 70)
                            Text("15 Days")
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .foregroundColor(.black)
                        }
                        
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 177, height: 188)
                            .clipShape(.rect(cornerRadius: 14))
                        VStack {
                            Text("All Time Record")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            VStack {
                                Image("Streak")
                                    .resizable()
                                    .frame(width: 31, height: 36)
                                    .padding(.bottom, -10)
                                HStack {
                                    Image("Streak")
                                        .resizable()
                                        .frame(width: 31, height: 36)
                                    Image("Streak")
                                        .resizable()
                                        .frame(width: 31, height: 36)
                                }
                            }
                            Text("49 Days")
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .foregroundColor(.black)
                        }
                    }
                }
                .foregroundColor(lightOrange)
                .padding(.top, -14)
                Text("Points")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                    .padding(.top, 10)
                ZStack {
                    Rectangle()
                        .foregroundColor(lightOrange)
                        .frame(width: 361, height: 196)
                        .clipShape(.rect(cornerRadius: 14))
                        .padding(.top, -14)
                    VStack {
                        HStack {
                            Text("Total")
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .foregroundColor(.black)
                                .padding(.trailing, 145)
                            Text("150")
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .foregroundColor(.black)
                            Image("StarBadge")
                        }
                        .padding(.bottom, 3)
                        
                        Divider()
                            .frame(maxWidth: 320, minHeight: 4)
                            .background(.gray)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Completed quiz")
                                Text("Date + Time")
                                    .font(.system(size: 14))
                                    .foregroundColor(.cMedGray)
                            }
                            .padding(.trailing, 110)
                            Text("+10")
                            Image("StarBadge")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.top, 15)
                        
                    }
                    .padding(.top, -70)
                }
            }
            //.padding(.top, 50)
        }
    }
}

#Preview {
    ActivityView(vm: ViewModel())
}
