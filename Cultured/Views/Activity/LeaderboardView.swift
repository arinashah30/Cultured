//
//  LeaderboardView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct LeaderboardEntry: View {
    @ObservedObject var vm: ViewModel
    var rank: Int
    var username: String
    var avatar: Image
    var streak: Int
    var badges: Int
    var points: Int
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 361, height: 86)
                .background(Color.cLightGray)
                .cornerRadius(20)
            HStack {
                Text("\(rank)")
                    .font(Font.custom("Quicksand-Semibold", size: 20))
                    .foregroundColor(.cDarkGray)
                    .bold()
                avatar
                    .resizable()
                    .scaledToFill()
                    .frame(width: 61, height: 61)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))

                VStack(alignment: .leading) {
                    Text(username)
                        .font(.system(size: 20))
                        .foregroundColor(.cDarkGray)
                    HStack {
                        Image("FireBadge")
                            .resizable()
                            .frame(width: 22, height: 25)
                        Text(streak.description)
                        Image("StarBadge")
                            .resizable()
                            .frame(width: 22, height: 25)
                        Text(points.description)
                        Image("ShieldBadge")
                            .resizable()
                            .frame(width: 22, height: 25)
                        Text(badges.description)
                    }
                }
            }
        }
    }
}

struct LeaderboardView: View {
    @ObservedObject var vm: ViewModel
    @State var users: [(String, Int, Int, Int, String)]
    
    var body: some View {

        VStack {
                
            HStack (alignment: .bottom) {
                VStack {
                    //Find a way to put the prof pic and info of the second place user
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 80, height: 124)
                            .background(Color(red: 0.99, green: 0.7, blue: 0.7))
                            .cornerRadius(10)
                        Text("2")
                            .font(Font.custom("Quicksand", size:40)
                                .weight(.bold))
                            .foregroundColor(.cDarkGray)
                    }
                    
                }
                VStack {
                    // First Place user
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 90, height: 158)
                            .background(Color(red: 1, green: 0.86, blue: 0.65))

                            .cornerRadius(10)
                        Text("1")
                            .font(Font.custom("Quicksand", size:64)
                                .weight(.medium))
                            .foregroundColor(.cDarkGray)
                    }
                    
                }
                VStack {
                    //Third place user
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 80, height: 97)
                            .background(Color(red: 0.6, green: 0.76, blue: 0.87))

                            .cornerRadius(10)
                        Text("3")
                            .font(Font.custom("Quicksand", size:40)
                                .weight(.bold))
                            .foregroundColor(.cDarkGray)
                        
                    }
            
                }
            }
            ScrollView {
                VStack {
                    ForEach(Array(users.enumerated()), id: \.element.0) { index, user in
                        LeaderboardEntry(vm: vm, rank: index + 1, username: user.0, avatar: vm.getPro, streak: user.2, badges: user.3, points: user.1)
                                                .padding(.vertical, 4)
                                        }
                }
            }
            
        }
        .onAppear(perform: {
            vm.getLeaderBoardInfo(completion: { users in
                if let users = users {
                    self.users = users
                }
            })
        })
    }
}


#Preview {
    LeaderboardView(vm: ViewModel())
}
