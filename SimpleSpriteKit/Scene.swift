//
//  Scene.swift
//  SimpleSpriteKit
//
//  Created by Betalantz on 9/26/17.
//  Copyright © 2017 Olivier Tests. All rights reserved.
//

//import SpriteKit
import ARKit


class Scene: SKScene {
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    var sight: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
        // Place targetting sight.png in center of screen
        sight = SKSpriteNode(imageNamed: "sight")
        addChild(sight)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        guard let currentFrame = sceneView.session.currentFrame,
//            let scene = SKScene(fileNamed: "Scene")
//            else { return }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
//        // Create anchor using the camera's current position
//        if let currentFrame = sceneView.session.currentFrame {
//
//            // Create a transform with a translation of 0.2 meters in front of the camera
//            var translation = matrix_identity_float4x4
//            translation.columns.3.z = -0.2
//            let transform = simd_mul(currentFrame.camera.transform, translation)
//
//            // Add a new anchor to the session
//            let anchor = ARAnchor(transform: transform)
//            sceneView.session.add(anchor: anchor)
//        }
    }
}
