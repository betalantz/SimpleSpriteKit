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
        // Places targetting sight.png in center of screen, could be alternated with a second .png in a ternary
        sight = SKSpriteNode(imageNamed: "sight")
        addChild(sight)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // An alternative touch trigger event to use beside the TapGestureRecognizer on the ViewController
        }
    
}
