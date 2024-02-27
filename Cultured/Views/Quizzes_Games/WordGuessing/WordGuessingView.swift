//
//  WordGuessingView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct WordGuessingView: View {
    @ObservedObject var vm: WordGuessingViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WordGuessingView(vm: WordGuessingViewModel())
}
