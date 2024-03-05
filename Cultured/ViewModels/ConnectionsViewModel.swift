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
    
    func playConnections() {
        
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
}
