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
    var selection: [Option]
    var answer_key: [String : [Option]]
    var history: [[String]]
    var correct_history: OrderedDictionary<String, [Option]>
    var mistake_history: OrderedDictionary<[Option], Bool>
    var mistakes_remaining: Int
    var attempts: Int
    var one_away: Bool
    var already_guessed: Bool
    var points: Int
    
    init(title: String, answer_key: [String: [String]], history: [[String]]) {
        self.title = title
        self.answer_key = [:]
        selection = []
        self.history = history
        mistake_history = [:]
        correct_history = [:]
        mistakes_remaining = 4
        attempts = 0
        one_away = false
        already_guessed = false
        points = 100
        
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
    
    init(title: String, categories: [String], answerKey: [String : [String]], options: [Option], selection: [Option], history: [[Option]], points: Int, attempts: Int, mistakes_remaining: Int, correct_categories: Int) {
            self.title = title
            self.categories = categories
            self.answerKey = answerKey
            self.options = options
            self.selection = selection
            self.history = history
            self.points = points
            self.attempts = attempts
            self.mistakes_remaining = mistakes_remaining
            self.correct_categories = correct_categories
    }
    
    mutating func select(_ option: Option) {
        let chosenIndex = index(of: option)
        if chosenIndex >= 0 {
            if !options[chosenIndex].isSelected {
                if selection.count < 4 {
                    options[chosenIndex].isSelected = true
                    selection.append(options[chosenIndex])
                }
            } else {
                options[chosenIndex].isSelected = false
                for index in selection.indices {
                    if selection[index].content == options[chosenIndex].content {
                        selection.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
    func index(of option: Option) -> Int {
        for index in options.indices {
            if options[index] == option {
                return index
            }
        }
        
        return -1
    }
    
    mutating func submit() {
        if selection.count == 4 {
            var temp_selection: [Option] = selection
            temp_selection.sort()
            
            for key in mistake_history.keys {
                var temp_key: [Option] = key
                temp_key.sort()
                
                if (temp_key == temp_selection) {
                    already_guessed = true
                    return
                }
            }
            
            var amount_correct: [String: Int] = [:]
            
            for index in selection.indices {
                let category: String = selection[index].category
                amount_correct.updateValue((amount_correct[category] ?? 0) + 1, forKey: category)
            }
            
            if amount_correct.values.contains(4) {
                for index in selection.indices {
                    for index2 in options.indices {
                        if options[index2].content == selection[index].content {
                            options[index2].isSelected = false
                            options.remove(at: index2)
                            break
                        }
                    }
                }
                
                correct_history.updateValue(selection, forKey: selection[0].category)
                selection = []
            } else if amount_correct.values.contains(3) {
                mistake_history.updateValue(true, forKey: selection)
                mistakes_remaining -= 1
                one_away = true
            } else {
                mistake_history.updateValue(false, forKey: selection)
                mistakes_remaining -= 1
            }
            
            if mistakes_remaining == 0 {
                options.removeAll()
                
                for (key, value) in answer_key {
                    if !correct_history.keys.contains(key) {
                        correct_history.updateValue(value, forKey: key)
                    }
                }
            }
            
            attempts += 1
        }
    }
    
    mutating func shuffle() {
        options.shuffle()
    }
    
    mutating func reset_alerts() {
        one_away = false
        already_guessed = false
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
