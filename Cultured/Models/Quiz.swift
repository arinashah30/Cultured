//
//  Quiz.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/8/24.
//

import Foundation

struct Quiz {
    var title: String
    var questions: [QuizQuestion]
    var points: Int = 0
    //var coverImage: Images
    var pointsGoal: Int = 0
}
