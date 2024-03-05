//
//  ConnectionsViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation

class ConnectionsViewModel: ObservableObject {
    @Published var current_user: User? = nil
    
    static func start_connections() -> Connections {
        return Connections() { index in
            return ["Fellow", "Spy", "Peep", "Birthmark", "Study", "Animal", "Peer", "Unit", "Bunny", "Hall", "Associate", "Egg", "Lounge", "Jelly Bean", "Library", "Partner"][index]
        }
    }
    
    @Published var current_connections_game: Connections? = start_connections()
    
    var options: [Connections.Option] {
        return current_connections_game!.options
    }
    
    func choose(_ option: Connections.Option) {
        current_connections_game!.choose(option)
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
    
}
