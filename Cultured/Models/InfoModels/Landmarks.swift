//
//  Landmarks.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Landmarks: Equatable {
    var landmarkMap: [String : String]

    //A "null" object to return
    init() {
        self.init(landmarkMap: [:]) // Initialize landmarkMap as an empty dictionary
    }

    //All Argument Constructor
    init(landmarkMap: [String : String]) {
        self.landmarkMap = landmarkMap
    }

    static func == (lhs: Landmarks, rhs: Landmarks) -> Bool {
        return lhs.landmarkMap == rhs.landmarkMap
   }
}
