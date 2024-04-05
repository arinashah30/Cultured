//
//  Connections.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/8/24.
//

import Foundation

struct Connections {
    private(set) var title: String
    private(set) var categories: [String]
    private(set) var answerKey: [String : [String]]
    private(set) var options: [Option]
    var selection: [Option]
    var history: [[Option]]
    var points: Int
    var attempts: Int
    var mistakes_remaining: Int
    var correct_categories: Int
    
    init(optionContent: (Int) -> String, optionCategory: (Int) -> String) {
        title = ""
        categories = []
        answerKey = [:]
        selection = []
        history = []
        points = 0
        attempts = 0
        mistakes_remaining = 4
        correct_categories = 0
        
        options = []
        
        for index in 0..<16 {
            let content = optionContent(index)
            let category = optionCategory(index)
            options.append(Option(id: "\(index + 1)", content: content, category: category))
        }
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
    
    init(title: String, answerKey: [String: [String]]) {
        self.init(title: title, categories: [], answerKey: answerKey, options: [], selection: [], history: [[]], points: 0, attempts: 0, mistakes_remaining: 0, correct_categories: 0)
    }
    
    mutating func select(_ option: Option) {
        let chosenIndex = index(of: option)
        if chosenIndex >= 0 {
            if !options[chosenIndex].isSubmitted {
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
    }
    
    func index(of option: Option) -> Int {
        for index in options.indices {
            if options[index].id == option.id {
                print(index)
                return index
            }
        }
        
        return -1
    }
    
    mutating func submit() {
        if selection.count == 4 {
            history.append(selection)
            if selection.allSatisfy({ $0.category == selection[0].category }) {
                for index in selection.indices {
                    for index2 in options.indices {
                        if options[index2].content == selection[index].content {
                            options[index2].isSubmitted = true
                            options[index2].isSelected = false
                            break
                        }
                    }
                }
                selection = []
                correct_categories += 1
            } else {
                mistakes_remaining -= 1
            }
            attempts += 1
        }
    }
    
    mutating func shuffle() {
        options.shuffle()
    }
    
    struct Option : Identifiable {
        var id: String
        
        var isSelected: Bool = false
        var isSubmitted: Bool = false
        let content: String
        let category: String
    }
}
