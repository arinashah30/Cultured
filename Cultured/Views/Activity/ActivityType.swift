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
