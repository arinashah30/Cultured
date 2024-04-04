//
//  StartWordGuessingView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct StartWordGuessingView: View {
    @ObservedObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var countryName: String
    @State var backgroundImage: Image
    
    let categories: [String] = ["Pop Culture", "Food", "Customs", "Places"]
    let categoryProgress: [Float] = [0.2, 0.8, 0.5, 0.7]
    
    var body: some View {
        StartXView(vm: ViewModel(), gameName: "Word Guessing", countryName: countryName, backgroundImage: backgroundImage, categories: categories, categoryProgress: categoryProgress)
    }
}

#Preview {
    StartWordGuessingView(vm: ViewModel(), countryName: "Country", backgroundImage: Image("WordGuessing"))
}
