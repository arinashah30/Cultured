//
//  StartConnectionsView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct StartConnectionsView: View {
    @ObservedObject var vm: ConnectionsViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StartConnectionsView(vm: ConnectionsViewModel())
}
