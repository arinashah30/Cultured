//
//  ConnectionsViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation
import OrderedCollections

class ConnectionsViewModel: ObservableObject {
    @Published var current_user: User? = nil
    
    static func start_connections() -> Connections { // add ongoing activity
        let answer_key: [String: [String]] = ["Pop megastars": ["Swift", "Mars", "Grande", "Styles"], "Method": ["Vehicle", "Means", "Medium", "Channel"], "Living ___": ["Large", "Legend", "Room", "Proof"], "Unlikely, as chances": ["Small", "Outside", "Slim", "Remote"]]
        let title = "TestConnectionsOne"
        
        return Connections(title: title, answer_key: answer_key)
    }
    
    @Published var current_connections_game: Connections? = start_connections()
    
    var options: [Connections.Option] {
        return current_connections_game!.options
    }
    
    var mistake_history: OrderedDictionary<[Connections.Option], Bool> {
        return current_connections_game!.mistake_history
    }
    
    var mistake_history_keys: [[Connections.Option]] {
        var store: [[Connections.Option]] = []
        for key in current_connections_game!.mistake_history.keys {
            store.append(key)
        }
        return store
    }
    
    var correct_history: OrderedDictionary<String, [Connections.Option]> {
        return current_connections_game!.correct_history
    }
    
    var correct_history_keys: [String] {
        var store: [String] = []
        for key in current_connections_game!.correct_history.keys {
            store.append(key)
        }
        return store
    }
    
    var selection: [Connections.Option] {
        return current_connections_game!.selection
    }
    
    var mistakes_remaining: Int {
        return current_connections_game!.mistakes_remaining
    }
    
    var one_away: Bool {
        return current_connections_game!.one_away
    }
    
    var already_guessed: Bool {
        return current_connections_game!.already_guessed
    }
    
    func select(_ option: Connections.Option) {
        print(option.content)
        let chosenIndex = index(of: option)
        if chosenIndex >= 0 {
            if !options[chosenIndex].isSelected {
                if selection.count < 4 {
                    current_connections_game!.options[chosenIndex].isSelected = true
                    current_connections_game!.selection.append(options[chosenIndex])
                }
            } else {
                current_connections_game!.options[chosenIndex].isSelected = false
                for index in selection.indices {
                    if selection[index].content == options[chosenIndex].content {
                        current_connections_game!.selection.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
    func index(of option: Connections.Option) -> Int {
        for index in options.indices {
            if options[index] == option {
                return index
            }
        }
        
        return -1
    }
    
    func submit() {
        if selection.count == 4 {
            var temp_selection: [Connections.Option] = selection
            temp_selection.sort()
            
            for key in mistake_history.keys {
                var temp_key: [Connections.Option] = key
                temp_key.sort()
                
                if (temp_key == temp_selection) {
                    current_connections_game!.already_guessed = true
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
                            current_connections_game!.options[index2].isSelected = false
                            current_connections_game!.options.remove(at: index2)
                            break
                        }
                    }
                }
                
                current_connections_game!.correct_history.updateValue(selection, forKey: selection[0].category)
                current_connections_game!.selection = []
            } else if amount_correct.values.contains(3) {
                current_connections_game!.mistake_history.updateValue(true, forKey: selection)
                current_connections_game!.mistakes_remaining -= 1
                current_connections_game!.one_away = true
            } else {
                current_connections_game!.mistake_history.updateValue(false, forKey: selection)
                current_connections_game!.mistakes_remaining -= 1
            }
            
            if mistakes_remaining == 0 {
                current_connections_game!.options.removeAll()
                
                for (key, value) in current_connections_game!.answer_key {
                    if !correct_history.keys.contains(key) {
                        current_connections_game!.correct_history.updateValue(value, forKey: key)
                    }
                }
            }
            
            current_connections_game!.attempts += 1
        }
    }
    
    func shuffle() {
        current_connections_game!.options.shuffle()
    }
    
    func reset_alerts() {
        current_connections_game!.one_away = false
        current_connections_game!.already_guessed = false
    }
}

    //METHOD IN PROGRESS
//    func getCategoryInfo(index: Int) -> [String] {
//        var infoArray : [String] = []
//        var category : String = Connections.categories[index]
//        
//        infoArray.append(category)
//        
//        var wordsOfCategory = Connections.answerKey[category]
//        
//        for word in wordsOfCategory {
//            infoArray.append(word)
//        }
//        
//        return infoArray
//    }
