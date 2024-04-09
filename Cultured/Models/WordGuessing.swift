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
    var history: [String] = []
    var stats: [Int] = []
    var isOver: Bool = false
    var hasWon: Bool = false
    var totalPoints: Int
    var current: Int
    
    init(title: String, options: [OptionTile], answer: String, history: [String], stats: [Int], won: Bool, totalPoints: Int, current: Int) {
        self.title = title
        self.options = options
        self.answer = answer
        self.history = history
        self.stats = stats
        if (history.count == 9) {
            isOver = true
        } else {
            isOver = false
        }
        self.hasWon = won
        self.totalPoints = totalPoints
        self.current = current
    }

    init(title: String, options: [OptionTile], answer: String, stats: [Int]) {
        self.init(title: title, options: options, answer: answer, history: [], stats: stats, won: false, totalPoints: 100, current: 0)
    }
}
