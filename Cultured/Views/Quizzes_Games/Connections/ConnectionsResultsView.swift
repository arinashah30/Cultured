//
//  ConnectionsResultsView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ConnectionsResultsView: View {
    @ObservedObject var vm: ConnectionsViewModel
    @State var categoryInfoList : [String]
    var body: some View {
        VStack {
            // IN PROGRESS
//            VStack (alignment: .leading) {
//                categoryInfoList = vm.getCategoryInfo(index: 0)
//            }
            
        }
    }
}

#Preview {
    ConnectionsResultsView(vm: ConnectionsViewModel(), categoryInfoList: [])
}
