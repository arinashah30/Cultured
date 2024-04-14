//
//  Dance.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Dance: Equatable {
    var danceDictionary: [String : String]
    
    //A "null" object to return
    init() {
        self.init(danceDictionary: [:]) // Initialize danceDictionary as an empty dictionary
    }
    
    //All Argument Constructor
    init(danceDictionary: [String : String]) {
        self.danceDictionary = danceDictionary
    }
    
    static func == (lhs: Dance, rhs: Dance) -> Bool {
        return lhs.danceDictionary == rhs.danceDictionary
   }
}
