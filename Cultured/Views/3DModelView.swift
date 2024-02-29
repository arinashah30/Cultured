//
//  ContentView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI
import RealityKit
import ARKit

let landmarks: [ARLandmark] = [
    ARLandmark(modelName: "Eiffel_Tower", numFacts: 2, color: .gray, scale: 0.025, isMetallic: true, facts: [TextBoxEntity(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", boxWidth: 0.3, boxHeight: 0.125)]),
    ARLandmark(modelName: "Pisa_Tower", numFacts: 2, color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), scale: 0.1, facts: [TextBoxEntity(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", boxWidth: 0.3, boxHeight: 0.13)]),
    ARLandmark(modelName: "Burj_Khalifa", numFacts: 2, color: nil, scale: 0.06, isMetallic: true, facts: [TextBoxEntity(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", boxWidth: 0.3, boxHeight: 0.13)]),
    ARLandmark(modelName: "Taj_Mahal", numFacts: 2, color: nil, scale: 0.02, facts: [TextBoxEntity(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", boxWidth: 0.3, boxHeight: 0.13)]),
    ARLandmark(modelName: "Chichen_Itza", numFacts: 2, color: nil, scale: 0.02, facts: [TextBoxEntity(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", boxWidth: 0.3, boxHeight: 0.13)]
    )
]


struct _DModelView : View {
    @State private var selection = 0
    var body: some View {
        ZStack{
            RealityViewContainer(model: landmarks[selection]).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Picker("Select a Country", selection: $selection) {
                    ForEach(0..<landmarks.count) { index in
                        Text(landmarks[index].modelName).tag(index)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .frame(width: 150, height: 40)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .alignmentGuide(.bottom) { _ in
                UIScreen.main.bounds.height * 0.05
            }
        }
    }
}

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

struct RealityViewContainer: UIViewRepresentable {
    
    var model: ARLandmark
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        updateUIView(arView, context: context)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        uiView.scene.anchors.removeAll()
        guard let modelEntity = try? ModelEntity.loadModel(named: model.modelName) else {
            return
        }
        
        if let color = model.color {
            var material = SimpleMaterial()
            material.color = .init(tint: color)
            material.metallic = MaterialScalarParameter(floatLiteral: model.isMetallic ? 1.0 : 0.0)
            modelEntity.model?.materials[0] = material
        }
        
        modelEntity.scale = [model.scale, model.scale, model.scale]
        
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [0.5, 0.5]))

        for textbox in model.facts {
            textbox.scale = [5,5,5]
            anchor.addChild(textbox)
            textbox.position = [Float(model.xDistance), 0, Float(-2)]
        }
        anchor.addChild(modelEntity)
        
        modelEntity.position = [Float(model.xDistance), 0, Float(model.zDistance)]
        for i in 0..<model.numFacts {
            var informationBubbleEntity = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.5), materials: [SimpleMaterial(color: .red, isMetallic: true)])
            let relativeTransform = Transform(translation: [Float(i) + 1, Float(i) + 1, Float(i) + 1])
            informationBubbleEntity.transform = relativeTransform
            modelEntity.addChild(informationBubbleEntity)
        }
        
        uiView.scene.addAnchor(anchor)
    }
    
}


#Preview {
    _DModelView()
}














