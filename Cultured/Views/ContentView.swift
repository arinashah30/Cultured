//
//  ContentView.swift
//  Cultured
//
//  Created by Ryan O’Meara on 3/5/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ViewModel
    @AppStorage("log_Status") var logStatus = false
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if (self.isActive) {
                if logStatus == true && vm.auth.currentUser != nil && vm.current_user != nil && vm.get_current_country() == "" {
                    CountrySetView(vm: vm)
                } else if logStatus == true && vm.auth.currentUser != nil && vm.current_user != nil && vm.get_current_country() != "" {
                    MainView(selectedView: .home, vm: vm)
                } else {
                    NavigationStack {
                        LogInView(vm: vm)
                    }
                }
            } else {
                Image("splashpage").resizable()
                    .background(Color(red: 255.0, green: 241.0, blue: 220.0)).ignoresSafeArea(.all)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        
        
    }
    
}

#Preview {
    ContentView(vm: ViewModel())
}
