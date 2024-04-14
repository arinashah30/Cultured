//
//  LeaderboardView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct LeaderboardEntry: View {
    var rank: Int
    var username: String
    var avatar: UIImage
    var streak: Int
    var badges: Int
    var points: Int
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.cLightGray)
                .cornerRadius(20)
            HStack {
                Text("\(rank)")
                    .font(Font.custom("Quicksand-Semibold", size: 20))
                    .foregroundColor(.cDarkGray)
                    .bold()
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 61, height: 61)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .padding(.trailing, 20)
                
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
                Spacer()
            }
            .padding()
        }
        .frame(width: 361, height: 86)
    }
}

struct LeaderboardView: View {
    @ObservedObject var vm: ViewModel
    @State var users: [Int: (String, Int, Int, Int, UIImage)] = [:]
    
    var body: some View {

        VStack {
                
            HStack (alignment: .bottom) {
                VStack {
                    //Find a way to put the prof pic and info of the second place user
                    Image(uiImage: users[2]?.4 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 61, height: 61)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(red: 0.99, green: 0.7, blue: 0.7), lineWidth: 4))
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
                    Image(uiImage: users[1]?.4 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 61, height: 61)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(red: 1, green: 0.86, blue: 0.65), lineWidth: 4))
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
                    Image(uiImage: users[3]?.4 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 61, height: 61)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(red: 0.6, green: 0.76, blue: 0.87), lineWidth: 4))
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
                    ForEach(users.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                        LeaderboardEntry(
                                            rank: key,
                                            username: value.0,
                                            avatar: value.4,
                                            streak: value.2,
                                            badges: value.3,
                                            points: value.1
                                        )
                                        .padding(.vertical, 4)
                                    }
                }
            }
            
        }
    }
}


//#Preview {
//    LeaderboardView(vm: ViewModel())
//}
