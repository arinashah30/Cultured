//
//  ConnectionsViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation

class ConnectionsViewModel: ObservableObject {
    var connections: [String : Connections] = [:]
    @Published var current_connections_game: Connections? = nil
    
    static func start_connections(category: String) {
        let optionsDict: [String: String] = ["Swift": "Pop megastars",
                                       "Vehicle": "Method",
                                       "Large": "Living ___",
                                       "Legend": "Living ___",
                                       "Small": "Unlikely, as chances",
                                       "Means": "Method",
                                       "Medium": "Method",
                                       "Mars": "Pop megastars",
                                       "Outside": "Unlikely, as chances",
                                       "Room": "Living ___",
                                       "Grande": "Pop megastars",
                                       "Slim": "Unlikely, as chances",
                                       "Proof": "Living ___",
                                       "Styles": "Pop megastars",
                                       "Remote": "Unlikely, as chances",
                                       "Channel": "Method"]
        let optionsContent: [String] = Array(optionsDict.keys)
        let optionsCategories: [String] = Array(optionsDict.values)
        
//        return Connections() { index in
//            return optionsContent[index]
//        } optionCategory: { index in
//            return optionsCategories[index]
//        }
    }
        
    var options: [Connections.Option] {
        return current_connections_game!.options
    }
    
    var history: [[Connections.Option]] {
        return current_connections_game!.history
    }
    
    var selection: [Connections.Option] {
        return current_connections_game!.selection
    }
    
    var mistakes_remaining: Int {
        return current_connections_game!.mistakes_remaining
    }
    
    var correct_categories: Int {
        return current_connections_game!.correct_categories
    }
    
    func select(_ option: Connections.Option) {
        current_connections_game!.select(option)
    }
    
    func submit() {
        current_connections_game!.submit()
    }
    
    func shuffle() {
        current_connections_game!.shuffle()
    }
    
    func get_amount_correct(submission: [String]) -> Int {
        var amountCorrect: Int = 0
        for category in current_connections_game!.categories {
            var answerOptions: [String] = current_connections_game!.answerKey[category]!
            for option in submission {
                for answerOption in answerOptions {
                    if (answerOption == option) {
                        amountCorrect += 1
                    }
                }
            }
        }
        
        if (amountCorrect == 4) {
            current_connections_game?.correct_categories += 1
        }
        
        if (current_connections_game?.correct_categories == 4) {
            return -1
        }
        
        return amountCorrect
    }
    
    func playConnections() {
        
    }
}
