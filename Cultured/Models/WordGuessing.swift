//
//  WordGuessing.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/8/24.
//

import Foundation

struct WordGuessing {
    var title: String
    var options: [OptionTile]
    var answer: String
    var totalPoints: Int = 100
    var flipPoints: Int = 10
    var flipsDone: Int = 0
    var numberOfGuesses: Int = 2
    
    
    init(title: String, options: [OptionTile], answer: String, totalPoints: Int, flipPoints: Int, flipsDone: Int, numberOfGuesses: Int) {
        self.title = title
        self.options = options
        self.answer = answer
        self.totalPoints = totalPoints
        self.flipPoints = flipPoints
        self.flipsDone = flipsDone
        self.numberOfGuesses = numberOfGuesses
    }
    
    init(title: String, options: [OptionTile], answer: String) {
        //set values to 0 as default
        self.init(title: title, options: options, answer: answer, totalPoints: 0, flipPoints: 0, flipsDone: 0, numberOfGuesses: 0)
        
    }
}
