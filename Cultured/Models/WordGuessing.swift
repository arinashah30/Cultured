//
//  WordGuessing.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/8/24.
//

import Foundation

struct WordGuessing {
    var title: String
    var options: [String]
    var answer: String
    var totalPoints: Int = 100
    var flipPoints: Int = 10
    var flipsDone: Int = 0
    var numberOfGuesses: Int = 2
}
