//
//  Celebrities.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Celebrities: Equatable {
    var celebritiesMap: [String : String]

    //A "null" object to return
    init() {
        self.init(celebritiesMap: [:]) // Initialize celebritiesMap as an empty dictionary
    }

    //All Argument Constructor
    init(celebritiesMap: [String : String]) {
        self.celebritiesMap = celebritiesMap
    }

    static func == (lhs: Celebrities, rhs: Celebrities) -> Bool {
        return lhs.celebritiesMap == rhs.celebritiesMap
   }
}
