//
//  ARVideoPortalView.swift
//  Cultured
//
//  Created by Arina Shah on 2/13/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARVideoPortalView: UIViewRepresentable {
    var model: ARLandmark
    @Binding var videoShown: Bool
    
    func updateUIView(_ uiView: ARViewController, context: Context) {

    }
    
    func makeUIView(context: Context) -> ARViewController {
        return ARViewController(videoName: model.video, videoShown: $videoShown)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: ARVideoPortalView
        init(_ parent: ARVideoPortalView) {
            self.parent = parent
        }
    }
}

class ARViewController: ARView {
    let videoName: String
    let videoType = "mp4"
    let spaceName = "SphereSpace.usdz"
    @Binding var videoShown: Bool

    var playerLooper: AVPlayerLooper!
    
    init(videoName: String, videoShown: Binding<Bool>) {
        self.videoName = videoName
        _videoShown = videoShown
        super.init(frame: . zero)
        createVideoSphere()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
        
    func createVideoSphere() {
        let anchorEntity = AnchorEntity()
        self.scene.addAnchor(anchorEntity)
        var spaceModelEntity: ModelEntity
        
        if let url = Bundle.main.url(forResource: videoName, withExtension: videoType) {
            let playerItem = AVPlayerItem(url: url)
            let player = AVQueuePlayer()
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            
            let material = VideoMaterial(avPlayer: player)
            do {
                spaceModelEntity = try Entity.loadModel(named: spaceName)
                
                spaceModelEntity.model?.materials = [material]
                anchorEntity.addChild(spaceModelEntity)
                print("before disable")
                //spaceModelEntity.isEnabled = false
                spaceModelEntity.generateCollisionShapes(recursive: false)
                spaceModelEntity.name = "spaceModel"
                self.installGestures([.rotation, .translation, .scale], for: spaceModelEntity as HasCollision)
                
                let handleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                self.addGestureRecognizer(handleTap) // calling the objc function
            } catch {
                assertionFailure("Could not load the USDZ asset.")
            }

            player.play()

        } else {
            assertionFailure("Could not load the video asset.")
        }
        
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = recognizer?.location(in: self) else {
            return
        }
        
        guard let modelEntity = self.entity(at: touchInView) as? ModelEntity else {
            print("modelEntity not found in handletap func")
            return
        }
        
        if (modelEntity.name == "spaceModel") {
            videoShown = false
        }
        
    }
}
