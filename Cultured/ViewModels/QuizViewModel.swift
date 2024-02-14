//
//  QuizViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var current_user: User? = nil
    @Published var current_quiz: Quiz? = nil
    
    func get_current_question() -> QuizQuestion {
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    
    func get_next_question() -> QuizQuestion {
        current_quiz?.currentQuestion += 1
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    
}
