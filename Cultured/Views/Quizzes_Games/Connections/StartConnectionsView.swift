//
//  StartConnectionsView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct StartConnectionsView: View {
    @ObservedObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var countryName: String
    @State var backgroundImage: Image
    
    let categories: [String] = ["Pop Culture", "Food", "Customs", "Places"]
    //let categoryProgress: [Float] = [0.25, 0.75, 0, 0.9]
    
    var body: some View {
        StartXView(vm: vm, gameName: "Connections", countryName: countryName, categories: categories)
    }
}

#Preview {
    StartConnectionsView(vm: ViewModel(), countryName: "Country", backgroundImage: Image("WordGuessing"))
}
