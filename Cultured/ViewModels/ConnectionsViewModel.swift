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
    
}
