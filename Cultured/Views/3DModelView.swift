//
//  ContentView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI
import RealityKit
import ARKit

struct _DModelView : View {
    var body: some View {
        RealityViewContainer(modelName: "Dice.imported", numFacts: 2).edgesIgnoringSafeArea(.all)
    }
}

struct RealityViewContainer: UIViewRepresentable {
    
    var modelName: String
    var numFacts: Int
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let modelEntity = try? ModelEntity.loadModel(named: modelName)
        
        
    
        guard let modelEntity else {
            return arView //add error message later
        }
        modelEntity.scale = [0.1, 0.1, 0.1]
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.5, 0.5]))
        anchor.addChild(modelEntity)
        for i in 0..<numFacts {
            var informationBubbleEntity = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.5), materials: [SimpleMaterial(color: .red, isMetallic: true)])
            let relativeTransform = Transform(translation: [Float(i) + 1, Float(i) + 1, Float(i) + 1])
                    informationBubbleEntity.transform = relativeTransform
            modelEntity.addChild(informationBubbleEntity)
        }
        
        arView.scene.addAnchor(anchor)
        return arView
        
    }

    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
}






#Preview {
    _DModelView()
}
