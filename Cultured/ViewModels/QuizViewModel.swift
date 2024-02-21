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
    
}
