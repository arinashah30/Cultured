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
        Button {
            
        } label: {
            Text("Food")
                .font(Font.custom("Quicksand-Bold", size: 20))
                .foregroundStyle(.white)
                .padding()
        }
            .frame(maxWidth: 160)
            .background(Color.cGreen)
            .clipShape(.rect(cornerRadius: 14.0))
    }
    
}

#Preview {
    HomeView(vm: ViewModel())
}
