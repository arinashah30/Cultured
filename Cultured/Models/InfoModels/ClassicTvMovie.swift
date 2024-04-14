//
//  ClassicTvMovie.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//
import Foundation

struct TvMovie {
    var actors: [String]
    var classics: [String]

    //A "null" object to return
    init() {
        self.init(actors: [], classics: []) // Initialize landmarkMap as an empty dictionary
    }

    //All Argument Constructor
    init(actors: [String], classics: [String]) {
        self.actors = actors
        self.classics = classics
    }

}
