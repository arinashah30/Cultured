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
    
    static func start_connections() -> Connections {
        let answer_key: [String: [String]] = ["Pop megastars": ["Swift", "Mars", "Grande", "Styles"], "Method": ["Vehicle", "Means", "Medium", "Channel"], "Living ___": ["Large", "Legend", "Room", "Proof"], "Unlikely, as chances": ["Small", "Outside", "Slim", "Remote"]]
        let title = "TestConnectionsOne"
        
        return Connections(title: title, answer_key: answer_key, history: [])
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
        current_connections_game!.select(option)
    }
    
    func submit() {
        current_connections_game!.submit()
    }
    
    func shuffle() {
        current_connections_game!.shuffle()
    }
    
    func reset_alerts() {
        current_connections_game!.reset_alerts()
    }
}
