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
    var color: UIColor? = nil
    var zDistance: Int = -2
    var xDistance: Int = 0
    var scale: Float
    var isMetallic: Bool = false
    var facts: [String]
    var video: String
}
