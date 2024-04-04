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
    let categoryProgress: [Float] = [0.2, 0.8, 0.5, 0.7]
    
    var body: some View {
        StartXView(vm: ViewModel(), gameName: "Quiz", countryName: countryName, backgroundImage: backgroundImage, categories: categories, categoryProgress: categoryProgress)
    }
}

#Preview {
    StartQuizView(vm: ViewModel(), countryName: "Country", backgroundImage: Image("StartQuizImage"))
}
