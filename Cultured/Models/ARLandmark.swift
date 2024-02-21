//
//  ARLandmark.swift
//  Cultured
//
//  Created by Arina Shah on 2/13/24.
//

import Foundation
import SwiftUI
import RealityKit

struct ARLandmark: Hashable {
    var modelName: String
    var numFacts: Int
    var color: UIColor? = nil
    var zDistance: Int = -6
    var xDistance: Int = 0
    var scale: Float
    var isMetallic: Bool = false
}
