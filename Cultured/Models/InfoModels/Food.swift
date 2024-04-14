//
//  Food.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Food {
    var regional: [String : String]
    var seasonal: [String : String]

    //A "null" object to return
    init() {
        self.init(regional: [:], seasonal: [:]) // Initialize landmarkMap as an empty dictionary
    }

    //All Argument Constructor
    init(regional: [String : String], seasonal: [String : String]) {
        self.regional = regional
        self.seasonal = seasonal
    }

}
