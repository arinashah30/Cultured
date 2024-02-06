//
//  HomeView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        Text("Home View")
    }
}

#Preview {
    HomeView(vm: ViewModel())
}
