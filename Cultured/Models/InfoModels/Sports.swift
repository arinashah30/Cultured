//
//  Sports.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Sports: Equatable {
    var athletes: [String]
    var sports: [String : String]
    
    //A "null" object to return
    init() {
        self.init(athletes: [], sports: [:])
    }
    
    //All Argument Constructor
    init(athletes: [String], sports: [String : String]) {
        self.athletes = athletes
        self.sports = sports
    }
    
    static func ==(lhs: Sports, rhs: Sports) -> Bool {
        return lhs.athletes == rhs.athletes && lhs.sports == rhs.sports
    }
    
}
