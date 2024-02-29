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
    ARLandmark(modelName: "Eiffel_Tower", color: .gray, scale: 0.025, isMetallic: true, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]),
    ARLandmark(modelName: "Pisa_Tower", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), scale: 0.1, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]),
    ARLandmark(modelName: "Burj_Khalifa", color: nil, scale: 0.06, isMetallic: true, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]),
    ARLandmark(modelName: "Taj_Mahal", color: nil, scale: 0.02, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]),
    ARLandmark(modelName: "Chichen_Itza", color: nil, scale: 0.02, facts: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."])
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
                RealityViewContainer(model: landmarks[selection], showPortalFunc: showARVideoPortal).edgesIgnoringSafeArea(.all)
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
            ARVideoPortalView()
        }
        
        
        
    }
    
    func showARVideoPortal() {
        videoShown.toggle()
    }
}

struct RealityViewContainer: UIViewRepresentable {
    
    var model: ARLandmark
    var showPortalFunc: () -> ()
    
    
    
    func updateUIView(_ uiView: RealityARView, context: Context) { 
        uiView.updateModel(model)
    }
    
    func makeUIView(context: Context) -> RealityARView {
        return RealityARView(model: model, showPortalFunc: showPortalFunc)
    }
    
    
}


class RealityARView: ARView {
    
    var model: ARLandmark {
        didSet {
            renderModel()
        }
    }
    var showPortalFunc: (() -> ())?
    var informationBubbles: [ModelEntity] = []
    var informationTextBoxes: [Entity] = []
    
    init(model: ARLandmark, showPortalFunc: @escaping () -> ()) {
        self.model = model
        self.showPortalFunc = showPortalFunc
        super.init(frame: . zero)
    }
    
    func updateModel(_ newModel: ARLandmark) {
        self.scene.anchors.removeAll()
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
        
        for fact in model.facts {
            var textbox = TextBoxEntity(text: fact, boxWidth: 0.3, boxHeight: 0.13)
            textbox.scale = [5,5,5]
            anchor.addChild(textbox)
            textbox.position = [Float(model.xDistance), 0, Float(-2)]
            informationTextBoxes.append(textbox)
            textbox.isEnabled = false //hides textbox at first
        }
        
        
        anchor.addChild(modelEntity)
        modelEntity.position = [Float(model.xDistance), 0, Float(model.zDistance)]
        
        modelEntity.name = model.modelName
        modelEntity.generateCollisionShapes(recursive: true)
        
        // adding the information bubbles
        for i in 0..<model.facts.count {
            var informationBubbleEntity = ModelEntity(mesh: MeshResource.generateSphere(radius: 15.0), materials: [SimpleMaterial(color: .red, isMetallic: true)])
            let relativeTransform = Transform(translation: [Float(i) + 1, Float(i) + 1, Float(i) + 1])
            informationBubbleEntity.transform = relativeTransform
            informationBubbleEntity.generateCollisionShapes(recursive: true) // adding collision boxes to each bubble
            informationBubbleEntity.name = "Fact " + String(i)
            modelEntity.addChild(informationBubbleEntity)
            informationBubbles.append(informationBubbleEntity)
        }
        
        self.scene.addAnchor(anchor)
        
        self.installGestures([.rotation, .translation, .scale], for: modelEntity as HasCollision)
        
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
            if let showPortalFunc {
                showPortalFunc()
            }
        } else if (modelEntity.name.prefix(4) == "Fact") {
            print("found a bubble")
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


#Preview {
    _DModelView()
}
