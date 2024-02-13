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
        RealityViewContainer(model: ARLandmark(modelName: "Eiffel_Tower", numFacts: 2, color: .gray)).edgesIgnoringSafeArea(.all)
    }
}

struct RealityViewContainer: UIViewRepresentable {
    
    var model: ARLandmark
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        guard let modelEntity = try? ModelEntity.loadModel(named: model.modelName) else {
            return arView
        }
        
        if let color = model.color {
            var material = SimpleMaterial()
            material.color = .init(tint: color)
            modelEntity.model?.materials[0] = material
        }
        
        
        modelEntity.scale = [0.1, 0.1, 0.1]
        
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [0.5, 0.5]))
        anchor.addChild(modelEntity)
        modelEntity.position = [0, 0, -10]
        for i in 0..<model.numFacts {
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
