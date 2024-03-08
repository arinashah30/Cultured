//
//  ARVideoPortalView.swift
//  Cultured
//
//  Created by Arina Shah on 2/13/24.
//

import SwiftUI
import RealityKit
import ARKit
import FirebaseCore
import FirebaseStorage

struct ARVideoPortalView: UIViewRepresentable {
    var model: ARLandmark
    @Binding var videoShown: Bool
    
    func updateUIView(_ uiView: ARViewController, context: Context) {

    }
    
    func makeUIView(context: Context) -> ARViewController {
        return ARViewController(modelName: model.modelName, videoName: model.video, videoShown: $videoShown)
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
    let modelName: String
    let videoName: String
    let videoType = "mp4"
    let spaceName = "SphereSpace.usdz"
    @Binding var videoShown: Bool

    var playerLooper: AVPlayerLooper!
    
    init(modelName: String, videoName: String, videoShown: Binding<Bool>) {
        self.modelName = modelName
        self.videoName = videoName
        _videoShown = videoShown
        super.init(frame: . zero)
        //createVideoSphere()
        retrieveVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func retrieveVideo() {
        let localURL = URL.documentsDirectory.appending(path: "videos/\(modelName).\(videoType)")
        
        if localURL.checkFileExist() {
            // video already downloaded
            createVideoSphere(localURL)
        } else {
            // download video first!
            downloadVideo { videoURL in
                self.createVideoSphere(videoURL)
            }
        }
    }
    
    func downloadVideo(_ closure: @escaping (URL) -> ()) {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "360videos/\(modelName).\(videoType)")
        let localURL = URL.documentsDirectory.appending(path: "videos/\(modelName).\(videoType)")
        
        // Download to the local filesystem
        let downloadTask = pathReference.write(toFile: localURL) { url, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
                fatalError("Could not load download model with name \(self.modelName)")
            } else {
                closure(localURL)
            }
        }
    }
        
    func createVideoSphere(_ videoURL: URL) {
        let anchorEntity = AnchorEntity()
        self.scene.addAnchor(anchorEntity)
        var spaceModelEntity: ModelEntity
        
        let playerItem = AVPlayerItem(url: videoURL)
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
        
        /*
        if let url = Bundle.main.url(forResource: videoName, withExtension: videoType) {
            

        } else {
            assertionFailure("Could not load the video asset.")
        }
         */
        
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

extension URL    {
    func checkFileExist() -> Bool {
        if FileManager.default.fileExists(atPath: self.path) {
            print("FILE AVAILABLE")
            return true
        } else {
            print("FILE NOT AVAILABLE")
            return false
        }
    }
}
