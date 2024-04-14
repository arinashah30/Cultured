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
    
    var body: some View {
        if logStatus == true && vm.auth.currentUser != nil && vm.current_user != nil && vm.get_current_country() == "" {
            CountrySetView(vm: vm)
        } else if logStatus == true && vm.auth.currentUser != nil && vm.current_user != nil && vm.get_current_country() != "" {
            MainView(selectedView: .home, vm: vm)
        } else {
            NavigationStack {
                LogInView(vm: vm)
            }
        }
    }
    
}

//#Preview {
//    ContentView(vm: ViewModel())
//}
