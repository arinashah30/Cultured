//
//  ContentView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI
import RealityKit
import ARKit
import FirebaseCore
import FirebaseStorage

let landmarks: [ARLandmark] = [
    
    ARLandmark(modelName: "Eiffel_Tower", color: .gray, scale: 0.025, isMetallic: true, facts: ["Symbol of Paris, Eiffel Tower stands tall, commemorating French Revolution, attracting global recognition.","Designed by Gustave Eiffel, erected for 1889 World's Fair, showcasing France's engineering prowess.", "Originally 300 meters tall, now 330 meters including antennas; tallest man-made structure during inauguration.", "Made of wrought iron, comprises 18,000 parts and 2.5 million rivets, surprisingly lightweight due to lattice design.", "Initially criticized, intended for dismantling post-Exposition Universelle but preserved for its radiotelegraphy utility."], textBoxWidths: [0.3,0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13,0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Pisa_Tower", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), scale: 0.1, facts: ["The Leaning Tower of Pisa is a medieval bell tower located in Pisa, Italy, famous for its unintended tilt caused by unstable ground.", "Construction began in 1173 and took over 200 years to complete due to various interruptions, including wars and engineering challenges.", "The tower's tilt began during its construction due to a weak foundation (only 3-meters deep) and uneven settling of the ground beneath it.", "Despite efforts to stabilize it, the tower still leans at an angle of ~3.97 degrees from the vertical.", "The tower is actually part of a larger cathedral complex, one that features the Bell Tower, the Cathedral, the Baptistery, and the Cemetery."], textBoxWidths: [0.3,0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13,0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Burj_Khalifa", color: nil, scale: 0.05, isMetallic: true, facts: ["Standing at 828 meters, Burj Khalifa is the tallest building in the world, located in Dubai, UAE, and took 6 years to construct.", "Burj Khalifa holds multiple world records, including the tallest structure, highest occupied floor, and longest elevator travel distance.", "It boasts the highest observation deck on the 148th floor, offering panoramic views of the city and beyond.", "It houses a luxurious hotel, Armani Hotel Dubai, along with residential apartments, offices, and entertainment facilities.","Its exterior features a sophisticated glass curtain wall system, designed to withstand high temperatures and winds.","The Burj Khalifa dazzles with LED light shows with music during national holidays and cultural festivals, illuminating Dubai's night sky."], textBoxWidths: [0.3,0.3,0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13,0.13,0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Taj_Mahal", color: nil, scale: 0.005, facts: ["The Taj Mahal, located in Agra, India, is a masterpiece commissioned by emperor Shah Jahan in memory of his wife, Mumtaz Mahal.", "After his death, Shah Jahan was laid to rest in the Taj Mahal beside the tomb of his wife Mumtaz.", "Constructed between 1631 and 1648, it is renowned for its stunning white marble mausoleum adorned with intricate inlay work.", "Recognized as one of the New Seven Wonders of the World, the Taj Mahal symbolizes eternal love and is a UNESCO World Heritage Site.","It took around 20 years to complete the Taj Mahal and some 20000 workers were employed in the construction work."], textBoxWidths: [0.3,0.3,0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13,0.13,0.13], video: "tower_bridge"),
    ARLandmark(modelName: "Chichen_Itza", color: nil, scale: 0.005, facts: ["Chichen Itza in Mexico is renowned for its stepped pyramid, El Castillo, dedicated to the serpent god Kukulkan.", "It served as a major center of Mayan civilization from around 600 AD to 1200 AD and is now a UNESCO World Heritage Site.", "Chichen Itza's astronomical significance is evident in its alignment with the equinoxes, creating a light and shadow effect on El Castillo.", "The site includes various structures such as the Temple of the Warriors, the Great Ballcourt, and the Sacred Cenote.","With over 100 million votes cast, Chichen Itza was chosen as one of the New 7 Wonders of the World in 2000."], textBoxWidths: [0.3,0.3,0.3,0.3,0.3], textBoxHeights: [0.13,0.13,0.13,0.13,0.13], video: "tower_bridge")
]

var modelsDictionary = ["France": 0, "Italy": 1, "UAE": 2, "India": 3, "Mexico": 4]


struct _DModelView : View {
    var model: String
    enum ViewShown {
        case Landmark, ARVideoPortal
    }
    
    @State var videoShown = false
    
    var body: some View {
        
        if (!videoShown) {
            ZStack(alignment: .topLeading) {
                
                LandmarkViewContainer(model: landmarks[modelsDictionary[model]!], videoShown: $videoShown).edgesIgnoringSafeArea(.all)
                BackButton()
            }.padding(.bottom, 50).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else {
            ARVideoPortalView(model: landmarks[modelsDictionary[model]!], videoShown: $videoShown)
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
    @ObservedObject var vm: ViewModel
    
    var model: ARLandmark {
        didSet {
            Task {
                await renderModel()
            }
        }
    }
    var showPortalFunc: (() -> ())?
    var informationBubbles: [ModelEntity] = []
    var informationTextBoxes: [Entity] = []
    var pointsGiven: [String:Bool] = [:]
    @Binding var videoShown: Bool
    
    let modelURL: URL?
    
    init(model: ARLandmark, videoShown: Binding<Bool>) {
        self.vm = ViewModel()
        self.modelURL = URL.documentsDirectory.appending(path: "models/\(model.modelName).usdz")
        self.model = model
        _videoShown = videoShown
        super.init(frame: . zero)
    }
    
    func updateModel(_ newModel: ARLandmark) {
        self.scene.anchors.removeAll()
        informationBubbles = []
        informationTextBoxes = []
        pointsGiven = [:]
        self.model = newModel
    }
    
    // errors that were generated by XCode
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func downloadModel(_ closure: @escaping (ModelEntity) -> ()) async {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "models/\(model.modelName).usdz")
        let localURL = URL.documentsDirectory.appending(path: "models/\(model.modelName).usdz")
        
        // Download to the local filesystem
        let downloadTask = pathReference.write(toFile: localURL) { url, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
                fatalError("Could not load download model with name \(self.model.modelName)")
            } else {
                guard let modelEntityLocal = try? ModelEntity.loadModel(contentsOf: localURL) else {
                    fatalError("Could not load download model with name \(self.model.modelName)")
                }
                closure(modelEntityLocal)
            }
        }
    }
    
    func renderModel() async {
        let localURL = URL.documentsDirectory.appending(path: "models/\(model.modelName).usdz")
        
        if let modelEntityLocal = try? ModelEntity.loadModel(contentsOf: localURL) {
            // model already downloaded
            renderModelSync(modelEntityLocal)
        } else {
            // download model
            await downloadModel { downloadedModel in
                self.renderModelSync(downloadedModel)
            }
        }
    }
    
    func renderModelSync(_ modelEntity: ModelEntity) {
        if let color = self.model.color {
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
            informationBubbleEntity.scale = [1,1,1]
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
            pointsGiven[informationBubbleEntity.name] = false //defaults all pointsGiven values to false
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
            
            // gives points if bubble is pressed for first time
            if (pointsGiven[modelEntity.name] == false) {
                pointsGiven[modelEntity.name] = true
                self.vm.update_points(userID: self.vm.current_user!.id, pointToAdd: 10, completion: { success in
                    print(success)
                })
            }
        }
        
        
    }
}

#Preview {
    _DModelView(model: "Mexico")
}



