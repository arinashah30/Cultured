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
        
        VStack {
            Text("Connections")
                .font(.title)
            Text("Group words together that culturally align")
                .font(.subheadline)
            Button("Play", action: vm.playConnections)
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
                .controlSize(.large)
                .clipShape(Capsule())
        }
        
    }
}

#Preview {
    StartConnectionsView(vm: ConnectionsViewModel())
}
