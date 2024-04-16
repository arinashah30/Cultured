//
//  StartQuizView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct StartQuizView: View {
    @ObservedObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var countryName: String
    @State var backgroundImage: Image
    
    let categories: [String] = ["Pop Culture", "Food", "Customs", "Places"]
    
    var body: some View {
        StartXView(vm: vm, gameName: "Quiz", countryName: vm.get_current_country(), categories: categories)
    }
}

//#Preview {
//    StartQuizView(vm: ViewModel(), countryName: "Country", backgroundImage: Image("StartQuizImage"))
//}
