//
//  ContentView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI
import RealityKit
import ARKit

let landmarks: [ARLandmark] = [ARLandmark(modelName: "Eiffel_Tower", numFacts: 2, color: .gray, xDistance: 0, scale: 0.025, isMetallic: true), ARLandmark(modelName: "Pisa_Tower", numFacts: 2, color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), xDistance: 4, scale: 0.1), ARLandmark(modelName: "Burj_Khalifa", numFacts: 2, color: nil, xDistance: -4, scale: 0.06, isMetallic: true), ARLandmark(modelName: "Taj_Mahal", numFacts: 2, color: nil, xDistance: -14, scale: 0.02), ARLandmark(modelName: "Chichen_Itza", numFacts: 2, color: nil, xDistance: 12, scale: 0.02)]

struct _DModelView : View {
    var body: some View {
        RealityViewContainer(models: landmarks).edgesIgnoringSafeArea(.all)
    }
    
}

struct RealityViewContainer: UIViewRepresentable {
    
    var models: [ARLandmark]
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        for model in models {
            
            guard let modelEntity = try? ModelEntity.loadModel(named: model.modelName) else {
                continue
            }
            
            if let color = model.color {
                var material = SimpleMaterial()
                material.color = .init(tint: color)
                material.metallic = MaterialScalarParameter(floatLiteral: model.isMetallic ? 1.0 : 0.0)
                modelEntity.model?.materials[0] = material
            }
            
        
            
            
            modelEntity.scale = [model.scale, model.scale, model.scale]
            
            
            let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [0.5, 0.5]))
            anchor.addChild(modelEntity)
            modelEntity.position = [Float(model.xDistance), 0, Float(model.zDistance)]
            for i in 0..<model.numFacts {
                var informationBubbleEntity = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.5), materials: [SimpleMaterial(color: .red, isMetallic: true)])
                let relativeTransform = Transform(translation: [Float(i) + 1, Float(i) + 1, Float(i) + 1])
                informationBubbleEntity.transform = relativeTransform
                modelEntity.addChild(informationBubbleEntity)
            }
            
            arView.scene.addAnchor(anchor)
        }
        return arView
        
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
}






#Preview {
    _DModelView()
}
