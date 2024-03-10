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
    ARLandmark(modelName: "Eiffel_Tower", color: .gray, scale: 0.025, isMetallic: true, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."], textBoxWidths: [0.3], textBoxHeights: [0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Pisa_Tower", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), scale: 0.1, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."], textBoxWidths: [0.3], textBoxHeights: [0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Burj_Khalifa", color: nil, scale: 0.06, isMetallic: true, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."], textBoxWidths: [0.3], textBoxHeights: [0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Taj_Mahal", color: nil, scale: 0.02, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."], textBoxWidths: [0.3], textBoxHeights: [0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Chichen_Itza", color: nil, scale: 0.02, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."], textBoxWidths: [0.3], textBoxHeights: [0.13], video: "tower_bridge")
]


struct _DModelView : View {
    @State private var selection = 0
    enum ViewShown {
        case Landmark, ARVideoPortal
    }
    
    @State var videoShown = false
    
    var body: some View {

        if (!videoShown) {
            ZStack{
                LandmarkViewContainer(model: landmarks[selection], videoShown: $videoShown).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer() // Pushes the VStack to the top
                    Picker("Select a Country", selection: $selection) {
                        ForEach(0..<landmarks.count) { index in
                            Text(landmarks[index].modelName).tag(index)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle()) // Apply a default picker style
                    .frame(width: 150, height: 40) // Set a fixed width and height for consistency
                    .background(.white) // Set a white background
                    .cornerRadius(10) // Apply corner radius for rounded edges
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .alignmentGuide(.bottom) { _ in
                    UIScreen.main.bounds.height * 0.05 // Adjust the value as needed
                }
            }
        } else {
            ARVideoPortalView(model: landmarks[selection], videoShown: $videoShown)
        }
        
    }
    
}

struct LandmarkViewContainer: UIViewRepresentable {
    
    var model: ARLandmark
    @Binding var videoShown: Bool
    
    
    
    func updateUIView(_ uiView: LandmarkARView, context: Context) {
        uiView.updateModel(model)
    }
    
    func makeUIView(context: Context) -> LandmarkARView {
        return LandmarkARView(model: model, videoShown: $videoShown)
    }
    
    
}


class LandmarkARView: ARView {
    
    var model: ARLandmark {
        didSet {
            renderModel()
        }
    }
    var showPortalFunc: (() -> ())?
    var informationBubbles: [ModelEntity] = []
    var informationTextBoxes: [Entity] = []
    @Binding var videoShown: Bool
    
    init(model: ARLandmark, videoShown: Binding<Bool>) {
        self.model = model
        _videoShown = videoShown
        super.init(frame: . zero)
    }
    
    func updateModel(_ newModel: ARLandmark) {
        self.scene.anchors.removeAll()
        informationBubbles = []
        informationTextBoxes = []
        self.model = newModel
    }
    
    // errors that were generated by XCode
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func renderModel() {
        guard let modelEntity = try? ModelEntity.loadModel(named: model.modelName) else {
            fatalError("Could not load model with name \(model.modelName)")
        }
        
        if let color = model.color {
            var material = SimpleMaterial()
            material.color = .init(tint: color)
            material.metallic = MaterialScalarParameter(floatLiteral: model.isMetallic ? 1.0 : 0.0)
            modelEntity.model?.materials[0] = material
        }
        
        
        modelEntity.scale = [model.scale, model.scale, model.scale]
        // addding the landmark to the view
        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [0.5, 0.5]))
        
        
        anchor.addChild(modelEntity)
        modelEntity.position = [Float(model.xDistance), 0, Float(model.zDistance)]
        
        modelEntity.name = model.modelName
        modelEntity.generateCollisionShapes(recursive: true)
        
        // adding the information bubbles
        for i in 0..<model.facts.count {
            let informationBubbleEntity = ModelEntity(mesh: MeshResource.generateSphere(radius: 5.0), materials: [SimpleMaterial(color: .red, isMetallic: true)])
            let relativeTransform = Transform(translation: [Float(i) + 1, Float(i) + 1, Float(i) + 1])
            informationBubbleEntity.transform = relativeTransform
            informationBubbleEntity.scale = [1,1,1]
            informationBubbleEntity.generateCollisionShapes(recursive: true) // adding collision boxes to each bubble
            informationBubbleEntity.name = "Fact " + String(i)
            modelEntity.addChild(informationBubbleEntity)
            informationBubbles.append(informationBubbleEntity)
            
            let textbox = TextBoxEntity(text: model.facts[i], boxWidth: CGFloat(model.textBoxWidths[i]), boxHeight: CGFloat(model.textBoxHeights[i]))
            textbox.scale = [50,50,50]
            informationBubbleEntity.addChild(textbox)
            textbox.position = [informationBubbleEntity.position.x + 12.5, informationBubbleEntity.position.y, informationBubbleEntity.position.z]
            informationTextBoxes.append(textbox)
            textbox.isEnabled = true //hides textbox at first
            print(textbox.position)
            print(informationBubbleEntity.position)
        }
        
        self.scene.addAnchor(anchor)
                
        let handleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(handleTap) // calling the objc function
    }
    
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = recognizer?.location(in: self) else {
            return
        }
        
        guard let modelEntity = self.entity(at: touchInView) as? ModelEntity else {
            print("modelEntity not found in handletap func")
            return
        }
        
        print("Tap detected on - \(modelEntity.name)")
        // detect tap on main model
        if (modelEntity.name == model.modelName) {
            videoShown = true
        } else if (modelEntity.name.prefix(4) == "Fact") {
            informationTextBoxes[Int(modelEntity.name.suffix(from: modelEntity.name.index(modelEntity.name.startIndex, offsetBy: 5)))!].isEnabled = !informationTextBoxes[Int(modelEntity.name.suffix(from: modelEntity.name.index(modelEntity.name.startIndex, offsetBy: 5)))!].isEnabled
        }
        
        
    }
}

#Preview {
    _DModelView()
}
