//
//  Connections.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/8/24.
//

import Foundation
import OrderedCollections

struct Connections {
    var title: String
    var options: [Option]
    var selection: [Option] = []
    var answer_key: [String : [Option]]
    var history: [[String]]
    var correct_history: OrderedDictionary<String, [Option]>
    var mistake_history: OrderedDictionary<[Option], Bool>
    var mistakes_remaining: Int
    var one_away: Bool = false
    var already_guessed: Bool = false
    var points: Int
    
    init(title: String, answer_key: [String: [String]]) {
        self.title = title
        self.answer_key = [:]
        history = []
        mistake_history = [:]
        correct_history = [:]
        mistakes_remaining = 4
        points = 0
        
        options = []
        
        for key in answer_key.keys {
            for value in answer_key[key]! {
                let option: Option = Option(content: value, category: key)
                options.append(option)
                if self.answer_key.keys.contains(key) {
                    self.answer_key[key]?.append(option)
                } else {
                    self.answer_key.updateValue([option], forKey: key)
                }
            }
        }
        
        options.shuffle()
    }
    
    struct Option : Hashable, Comparable {
        static func < (lhs: Connections.Option, rhs: Connections.Option) -> Bool {
            return lhs.content < rhs.content
        }
        
        var isSelected: Bool = false
        let content: String
        let category: String
    }
}
