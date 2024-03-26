//
//  LeaderboardView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

/*
 I created a separate struct for each LeaderBoard entry, and tried including some variables for future implementation and syncing with the backend.
 The view certainly won't look good or correct as of now, but once I get my environment running
 it will take another hour or so of work.
 */
struct LeaderboardEntry: View {
    var rank: Int
    var username: String
    var avatar: Image
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 361, height: 86)
                .background(Color.cOrange)
                .cornerRadius(20)
            HStack {
                Text("\rank")
                    .font(Font.custom("Quicksand-Semibold", size: 20))
                    .foregroundColor(.cDarkGray)
                    .bold()
                Image("PlaceHolderAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 61, height: 61)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))

                VStack {
                    Text("Username")
                        .font(.system(size: 20))
                        .foregroundColor(.cDarkGray)
                    HStack {
                        Image("FireBadge")
                            .resizable()
                            .frame(width: 22, height: 25)
                        Image("StarBadge")
                            .resizable()
                            .frame(width: 22, height: 25)
                        Image("ShieldBadge")
                            .resizable()
                            .frame(width: 22, height: 25)
                    }
                }
            }
        }
    }
}

struct LeaderboardView: View {
    
    var sizeUserList: Int
    
    var body: some View {
        ZStack {
            Image("Earth")
                .resizable()
                .frame(width: 390, height: 618)
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 390, height: 618)
                .background(.white)
                .cornerRadius(40)
            VStack {
                Text("Leaderboard")
                    .font(Font.custom("Quicksand-Semibold", size: 32))
                    .foregroundColor(.white)
                HStack {
                    VStack {
                        //Find a way to put the prof pic and info of the second place user
                    }
                    VStack {
                        // First Place user
                    }
                    VStack {
                        //Third place user
                    }
                }
                ScrollView {
                    VStack {
                        ForEach(0..<sizeUserList) { index in
                            // Need to make the relevant leaderboard entry given the user
                            //LeaderboardEntry{}
                        }
                    }
                }
                
            }
        }
    }
}


#Preview {
    LeaderboardView()
}
