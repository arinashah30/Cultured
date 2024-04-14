//
//  DynamicNavigationView.swift
//  Cultured
//
//  Created by Austin Huguenard on 4/9/24.
//

import SwiftUI

struct DynamicNavigationView: View {
    @ObservedObject var vm: ViewModel
    var gameName: String
    
    var body: some View {
        Group {
            if gameName == "WordGuessing" {
                WordGuessingView(vm: vm.wordGuessingViewModel!, localHasWon: vm.wordGuessingViewModel!.current_word_guessing_game?.isOver ?? false)
            } else if gameName == "Quiz" {
                if vm.quizViewModel!.current_quiz!.completed || vm.quizViewModel!.current_quiz!.currentQuestion == vm.quizViewModel!.current_quiz!.questions.count {
                    ResultsView(vm: vm.quizViewModel!)
                } else {
                    QuestionView(vm: vm.quizViewModel!)
                }
            } else {
                ConnectionsGameView(vm: vm.connectionsViewModel!)
            }
        }
    }
}

//#Preview {
//    DynamicNavigationView()
//}
