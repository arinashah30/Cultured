//
//  StartQuizView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct StartQuizView: View {
    @ObservedObject var vm: QuizViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StartQuizView(vm: QuizViewModel())
}
