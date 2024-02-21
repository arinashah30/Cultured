//
//  HomeView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: ViewModel
    @State var bindingVar: Bool = false
    var body: some View {
        Text("Home View")
        Button {
            vm.update_points(userID: "dummyUsername_12", pointToAdd: 100) { boolean in
                bindingVar = boolean
            }
        } label: {
            Text("Update Points: 50")
        }
    }
    
}

#Preview {
    HomeView(vm: ViewModel())
}
