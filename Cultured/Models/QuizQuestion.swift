//
//  QuizQuestion.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/8/24.
//

import Foundation
import UIKit

struct QuizQuestion {
    var question: String
    var answers: [String]
    var correctAnswer: Int
    var image: UIImage? = nil
    var correctAnswerDescription: String
    var submitted: Bool = false
}
