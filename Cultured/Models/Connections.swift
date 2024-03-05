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
    var points: Int
    var attempts: Int
    var correct_categories: Int
    
    init(optionContent: (Int) -> String) {
        title = ""
        categories = []
        answerKey = [:]
        points = 0
        attempts = 0
        correct_categories = 0
        
        options = []
        
        for index in 0..<16 {
            let content = optionContent(index)
            options.append(Option(id: "\(index + 1)", content: content))
        }
    }
    
    var indexOfSelectedOption : Int?
    
    mutating func choose(_ option: Option) {
        // all structs are value types, which means that whenever a struct is passed into a function. a copy of it is passed in. To change the card in our View to be face up, we need to modify the actual cards in the model, not the copied card that is passed into our function
        //card.isFaceUp.toggle()
        let chosenIndex = index(of: option)
        if chosenIndex >= 0 {
            // Only change cards if they're not already face up or matched
            if !options[chosenIndex].isSelected && !options[chosenIndex].isMatched {
                // [if let] only lets you enter the if block if you're able to find a non-nil value for the constant. If indexOfFaceUpCard is nil (meaning there's no face up card), we skip the if block
                if let matchIndex = indexOfSelectedOption {
                    // Check if the content in chosen card matches face up card, and if does, set both cards as being matched. Reset indexOfFaceUpCard to nil otherwise
                    if options[chosenIndex].content == options[matchIndex].content {
                        options[chosenIndex].isMatched = true
                        options[matchIndex].isMatched = true
                    }
                    indexOfSelectedOption = nil
                } else {
                    // Flips back over all the cards, and stores the index of current card you selected in indexOfFaceUpCard
                    for index in options.indices {
                        options[index].isSelected = false
                    }
                    indexOfSelectedOption = chosenIndex
                }
                options[chosenIndex].isSelected = true
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
    
    mutating func shuffle() {
        options.shuffle()
    }
    
    struct Option : Identifiable {
        var id: String
        
        var isSelected: Bool = false
        var isMatched: Bool = false
        let content: String
    }
}
