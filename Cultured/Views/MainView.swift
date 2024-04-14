//
//  ContentView.swift
//  Cultured
//
//  Created by Arina Shah on 2/4/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedView: TabSelection = .home
    @ObservedObject var vm: ViewModel
    var body: some View {
        
        TabView(selection: $selectedView,
                content:  {
            LeaderboardView(vm: vm).tabItem {
                VStack {
                    Image(systemName: "trophy.fill")
                    Text("Activity")
                }
            }.tag(TabSelection.activity)
            HomeView(vm: vm).tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }.tag(TabSelection.home)
            SelfProfileView(vm: vm).tabItem {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                 }.tag(TabSelection.profile)
        })
        .accentColor(.cDarkGray)
        .onAppear() {
        }
    }
}

enum TabSelection {
    case home, activity, profile
}

#Preview {
    MainView(vm: ViewModel())
}
