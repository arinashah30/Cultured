//
//  MajorCities.swift
//  Cultured
//
//  Created by Ganden Fung on 4/9/24.
//

import Foundation
struct MajorCities: Equatable {
    var majorCitiesMap: [String : String]
    //A "null" object to return
    init() {
        self.init(majorCitiesMap: [:])
    }
    //All Argument Constructor
    init(majorCitiesMap: [String : String]) {
        self.majorCitiesMap = majorCitiesMap
    }
    static func == (lhs: MajorCities, rhs: MajorCities) -> Bool {
        return lhs.majorCitiesMap == rhs.majorCitiesMap
   }
}

