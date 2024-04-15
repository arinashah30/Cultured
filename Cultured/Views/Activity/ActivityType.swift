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
    @State var users: [Int: (String, Int, Int, Int, UIImage)] = [:]
    
    var body: some View {
        VStack {
            // This is the segmented control
            Picker("Select", selection: $selectedSegment) {
                ForEach(DashboardSegment.allCases) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .foregroundColor(Color.cOrange)
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Based on the selection, show the corresponding view
            switch selectedSegment {
            case .activity:
                ActivityView(vm: vm, badges: vm.current_user?.badges ?? [])
            case .leaderboard:
                LeaderboardView(vm: vm, users: users)
            }
            
            Spacer()
        }
        .navigationTitle("Dashboard")
        .onAppear(perform: {
            vm.getLeaderBoardInfo(completion: { users in
                print("USERS \(users)")
                self.users = users
            })
           
        })
        .onAppear {
            UISegmentedControl.appearance().backgroundColor = UIColor(Color.cOrange)
            UISegmentedControl.appearance().selectedSegmentTintColor = .white
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
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
