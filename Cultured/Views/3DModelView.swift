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
    ARLandmark(modelName: "Eiffel_Tower", color: .gray, scale: 0.025, isMetallic: true, facts: ["Symbol of Paris, Eiffel Tower stands tall, commemorating French Revolution, attracting global recognition","Designed by Gustave Eiffel, erected for 1889 World's Fair, showcasing France's engineering prowess.", "Originally 300 meters tall, now 330 meters including antennas; tallest man-made structure during inauguration", "Made of wrought iron, comprises 18,000 parts and 2.5 million rivets, surprisingly lightweight due to lattice design", "Initially criticized, intended for dismantling post-Exposition Universelle but preserved for its radiotelegraphy utility"], textBoxWidths: [0.3,0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13,0.13], video: "tower_bridge"),
        ARLandmark(modelName: "Pisa_Tower", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), scale: 0.1, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Shaunak shaunak shaunak", "Wow i am cultured", "Micheal Jordan the goat"], textBoxWidths: [0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13], video: "tower_bridge"),
        ARLandmark(modelName: "Burj_Khalifa", color: nil, scale: 0.05, isMetallic: true, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Shaunak shaunak shaunak", "Wow i am cultured", "Micheal Jordan the goat"], textBoxWidths: [0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13], video: "tower_bridge"),
        ARLandmark(modelName: "Taj_Mahal", color: nil, scale: 0.005, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Shaunak shaunak shaunak", "Wow i am cultured", "Micheal Jordan the goat"], textBoxWidths: [0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13], video: "tower_bridge"),
        ARLandmark(modelName: "Chichen_Itza", color: nil, scale: 0.005, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Shaunak shaunak shaunak", "Wow i am cultured", "Micheal Jordan the goat"], textBoxWidths: [0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13], video: "tower_bridge")
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
        
        let box = modelEntity.visualBounds(relativeTo: nil)
        let size = box.extents
        let bubbleRadius: Float = 15.0 / (40.0 * model.scale) // 40.0 is the constant to reduce the value depending on scale
        print("Radius: " + String(bubbleRadius) + " Scale " + String(model.scale) + " Name: " + model.modelName)
        var isEven: Float = 1.0
        // adding the information bubbles
        for i in 0..<model.facts.count {
            let informationBubbleEntity = ModelEntity(mesh: MeshResource.generateSphere(radius: bubbleRadius), materials: [SimpleMaterial(color: .red, isMetallic: true)])
            let relativeTransform = Transform(translation: [isEven * (bubbleRadius * 2.0 + Float(2.0 / (3.0 * model.scale)) * Float(size.x)), 2.0 * Float(i / 2) * (bubbleRadius + Float(1.0 / (9.0 * model.scale)) * Float(size.y)), bubbleRadius + Float(size.z)])
            informationBubbleEntity.transform = relativeTransform
            informationBubbleEntity.generateCollisionShapes(recursive: true) // adding collision boxes to each bubble
            informationBubbleEntity.name = "Fact " + String(i)
            modelEntity.addChild(informationBubbleEntity)
            informationBubbles.append(informationBubbleEntity)
            isEven = -1.0 * isEven
            
            let textbox = TextBoxEntity(text: model.facts[i], boxWidth: CGFloat(model.textBoxWidths[i]), boxHeight: CGFloat(model.textBoxHeights[i]))
            textbox.scale = [15 * bubbleRadius,15 * bubbleRadius,15 * bubbleRadius]
            informationBubbleEntity.addChild(textbox)
            textbox.position = [-1 * isEven * bubbleRadius * 3.5, 0, bubbleRadius * 1.5]
            informationTextBoxes.append(textbox)
            textbox.isEnabled = false //hides textbox at first
        }
        
        self.scene.addAnchor(anchor)
        
        //        self.installGestures([.rotation, .translation, .scale], for: modelEntity as HasCollision)
        
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
            print("Heyyy")
        } else if (modelEntity.name.prefix(4) == "Fact") {
            informationTextBoxes[Int(modelEntity.name.suffix(from: modelEntity.name.index(modelEntity.name.startIndex, offsetBy: 5)))!].isEnabled = !informationTextBoxes[Int(modelEntity.name.suffix(from: modelEntity.name.index(modelEntity.name.startIndex, offsetBy: 5)))!].isEnabled
        }
        
        
    }
}

#Preview {
    _DModelView()
}



