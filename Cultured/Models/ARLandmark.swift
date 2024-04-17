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
    var zDistance: Float = -1.5
    var yDistance: Float = -0.5
    var xDistance: Float = 0
    var scale: Float
    var isMetallic: Bool = false
    var facts: [String]
    var textBoxWidths: [Float]
    var textBoxHeights: [Float]
    var video: String
}
