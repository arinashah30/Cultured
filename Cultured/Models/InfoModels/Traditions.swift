//
//  Traditions.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Traditions: Equatable {
    var traditionsDictionary: [String : String]
    
    //A "null" object to return
    init() {
        self.init(traditionsDictionary: [:]) // Initialize traditionsDictionary as an empty dictionary
    }
    
    //All Argument Constructor
    init(traditionsDictionary: [String : String]) {
        self.traditionsDictionary = traditionsDictionary
    }
    
    static func == (lhs: Traditions, rhs: Traditions) -> Bool {
        return lhs.traditionsDictionary == rhs.traditionsDictionary
   }
}
