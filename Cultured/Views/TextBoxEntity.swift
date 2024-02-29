//
//  TextBoxEntity.swift
//  Cultured
//
//  Created by Arina Shah on 2/29/24.
//

import Foundation
import RealityKit

class TextBoxEntity: Entity {
    init(text: String, boxWidth: CGFloat, boxHeight: CGFloat) {
        super.init()


        // Create a plane for the background
        let boardWidth: CGFloat = boxWidth
        let boardHeight: CGFloat = boxHeight
        let textWidth: CGFloat = boardWidth - 0.02
        let textHeight: CGFloat = boardHeight - 0.02

        let boardEntity = ModelEntity(
            mesh: .generatePlane(width: Float(boardWidth), height: Float(boardHeight), cornerRadius: 0.01),
            materials: [SimpleMaterial(
                color: .white,
                isMetallic: false)
            ]
        )
        self.addChild(boardEntity)

        let textYPosition = -(Float(boardHeight) / 2.0) + 0.01
        let textXPosition = -(Float(boardWidth) / 2.0) + 0.01

        let textContainerFrame = CGRect(x: CGFloat(textXPosition), y: CGFloat(textYPosition), width: textWidth, height: textHeight)

        // Create an entity for the text
        let textEntityMesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.004,
            font: .systemFont(ofSize: 0.017, weight: .bold),
            containerFrame: textContainerFrame,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )

        let textEntity = ModelEntity(mesh: textEntityMesh, materials: [SimpleMaterial(color: .black, isMetallic: false)])
        self.addChild(textEntity)

    }

    required init() {
        fatalError("init() has not been implemented")
    }
}
