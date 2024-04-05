//
//  Etiquette.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Etiquette: Equatable {
    var etiquetteMap: [String : String]
    
    //A "null" object to return
    init() {
        self.init(etiquetteMap: [:]) // Initialize etiquetteMap as an empty dictionary
    }
    
    //All Argument Constructor
    init(etiquetteMap: [String : String]) {
        self.etiquetteMap = etiquetteMap
    }
    
    static func == (lhs: Etiquette, rhs: Etiquette) -> Bool {
        return lhs.etiquetteMap == rhs.etiquetteMap
   }
}
