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
                .background(Color.cBar)
                .cornerRadius(20)
            HStack {
                Text("\(rank)")
                    .font(Font.custom("Quicksand-Semibold", size: 20))
                    .foregroundColor(.cDarkGray)
                    .bold()
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

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
    @State var users: [Int: (String, Int, Int, Int, UIImage, String)] = [:]
    @State var userToProfile: [String:UIImage] = [:]
    
    var body: some View {

        VStack {
                
            HStack (alignment: .bottom) {
                VStack {
                    //Find a way to put the prof pic and info of the second place user
                    Image(uiImage: ((Array(self.userToProfile.keys).firstIndex(of: users[2]?.0 ?? "") != nil ? self.userToProfile[users[2]!.0] : users[2]?.4 ?? UIImage())!))
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
                            .foregroundColor(.cDarkGrayConstant)
                    }
                    
                }
                VStack {
                    // First Place user
                    Image(uiImage: ((Array(self.userToProfile.keys).firstIndex(of: users[1]?.0 ?? "") != nil ? self.userToProfile[users[1]!.0] : users[1]?.4 ?? UIImage())!))
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
                            .foregroundColor(.cDarkGrayConstant)
                    }
                    
                }
                VStack {
                    //Third place user
                    Image(uiImage: ((Array(self.userToProfile.keys).firstIndex(of: users[3]?.0 ?? "") != nil ? self.userToProfile[users[3]!.0] : users[3]?.4 ?? UIImage())!))
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
                            .foregroundColor(.cDarkGrayConstant)
                        
                    }
            
                }
            }
            ScrollView {
                VStack {
                    ForEach(users.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        LeaderboardEntry(
                            rank: key,
                            username: value.0,
                            avatar: ((Array(self.userToProfile.keys).firstIndex(of: value.0) != nil ? self.userToProfile[value.0] : value.4)!),
                            streak: value.2,
                            badges: value.3,
                            points: value.1
                        )
                        .padding(.vertical, 4)
                    }
                }
            }
            
        }
        .onAppear(perform: {
            vm.getLeaderBoardInfo(completion: { users in
                print("USERS \(users)")
                for user in users {
                    let value = user.value
                    if (value.5 != "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png") {
                        userToProfile.updateValue(value.4, forKey: value.0)
                    }
                }
                self.users = users
            })
           
        })
    }
}


//#Preview {
//    LeaderboardView(vm: ViewModel())
//}
