//
//  ConnectionsViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation

class ConnectionsViewModel: ObservableObject {
    @Published var current_user: User? = nil
    @Published var current_connections_game: Connections? = nil
    
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
    
    func start_connections() {
        current_connections_game = Connections(title: "Title", categories: ["Category 1", "Category 2"], options: ["Option 1","Option 2"], answerKey: ["Category 1" : ["Answer 1", "Answer 2"], "Category 2" : ["Answer 1", "Answer 2"], "Category 3" : ["Answer 1", "Answer 2"], "Category 4" : ["Answer 1", "Answer 2"]], points: 0, attempts: 0, correct_categories: 0)
    }
    
}
