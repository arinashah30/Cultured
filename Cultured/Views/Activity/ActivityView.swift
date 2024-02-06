//
//  ActivityView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        Text("Activity View")
    }
}

#Preview {
    ActivityView(vm: ViewModel())
}
