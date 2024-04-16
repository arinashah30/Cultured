//
//  ActivityType.swift
//  Cultured
//
//  Created by Austin Huguenard on 4/14/24.
//

import SwiftUI

struct ActivityType: View {
    @State private var selectedSegment: DashboardSegment = .activity
    @State var vm: ViewModel
    @State var users: [Int: (String, Int, Int, Int, UIImage, String)] = [:]
    @State var userToProfile: [String:UIImage] = [:]
    
    var body: some View {
        VStack {
            // This is the segmented control
            Picker("Select", selection: $selectedSegment) {
                ForEach(DashboardSegment.allCases) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .foregroundColor(Color.cBar)
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Based on the selection, show the corresponding view
            switch selectedSegment {
            case .activity:
                ActivityView(vm: vm, badges: vm.current_user?.badges ?? [])
            case .leaderboard:
                LeaderboardView(vm: vm, userToProfile: userToProfile)
            }
            
            Spacer()
        }
        .navigationTitle("Dashboard")
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
        .onAppear {
            UISegmentedControl.appearance().backgroundColor = UIColor(Color.cBar)
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.cPopover)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.cDarkGray], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.cDarkGray], for: .normal)
        }
        
//        init() {
//            UISegmentedControl.appearance().selectedSegmentTintColor = .blue
//            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
//        }

    }
}

enum DashboardSegment: String, CaseIterable, Identifiable {
    case activity = "Activity"
    case leaderboard = "Leaderboard"

    var id: String { self.rawValue }
}

#Preview {
    ActivityType(vm: ViewModel())
}
