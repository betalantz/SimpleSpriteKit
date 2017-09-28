//
//  ViewController.swift
//  SimpleSpriteKit
//
//  Created by Betalantz on 9/26/17.
//  Copyright © 2017 Olivier Tests. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Vision

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet weak var sceneView: ARSKView!
   
    @IBOutlet weak var targetingLabel: UILabel!
    
    // Variable for storing the barcode request
    var qRRequest:VNDetectBarcodesRequest?
    // Creates a new timer object
    var qRTimer = Timer()
    var qRCenter: CGPoint?
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = Scene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sceneView.presentScene(scene)
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true



        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        setupVisionRequest()
        
        // Starts our timer which will detect QR codes on a loop
        scheduledTimerWithTimeInterval()
    }
    
    /************************/
    /* The QR Functionality */
    /************************/
    
    // Setup for a barcode detector object, which will scan for barcodes, and process the results
    func setupVisionRequest(){
        qRRequest = VNDetectBarcodesRequest(completionHandler: {
            (request, error) in
            // Loop through the found results
            for result in request.results! {
                // Cast the result to a barcode-observation
                if let barcode = result as? VNBarcodeObservation {
                    // Get the bounding box for the bar code and find the center
                    var rect = barcode.boundingBox
                    rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
                    rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
                    let center = CGPoint(x: rect.midX, y: rect.midY)
                    self.qRCenter = center
                    print ("Payload: \(barcode.payloadStringValue!) at \(center)")
                    self.isTargeted()
                }
            }
        })
    }
    
    // Gets the current image from the ARSKView (Augmented Reality Sprite Kit View) and makes an Image Request Handler using that image.
    // It then calls the handler's perform method, and passes it the request we made earlier.
    @objc func detectQR(){
        let cameraCurrent = sceneView.session.currentFrame?.capturedImage
        let visionImageHandler = VNImageRequestHandler(cvPixelBuffer: cameraCurrent!, options: [.properties : ""])
        guard let _ = try? visionImageHandler.perform([qRRequest!]) else {
            return print("Could not perform barcode-request!")
        }
    }
    
    // Starts a timer with a callback of the QR detection function. Repeats every 1 seconds.
    func scheduledTimerWithTimeInterval(){
        qRTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.detectQR), userInfo: nil, repeats: true)
    }
    
    /********************************/
    /* Targetting    */
    /********************************/
    
    func isTargeted() -> Bool {
        if let realCenter = qRCenter{
            if realCenter.x > 0.45
                && realCenter.x < 0.55
                && realCenter.y > 0.42
                && realCenter.y < 0.57 {
                targetingLabel.isHidden = false
                return true
            } else {
                targetingLabel.isHidden = true
            }
        }
        return false
    }
    
    /********************************/
    /* Firing   */
    /********************************/
    
    
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) {
        print("Tapped!")
        self.playSoundEffect(ofType: .torpedo)
        let inTarget = isTargeted()
        if inTarget {
            print("Hit!")
        }
    }
    
    
    
    func playSoundEffect(ofType effect: SoundEffect) {
        
        // Async to avoid substantial cost to graphics processing (may result in sound effect delay however)
        DispatchQueue.main.async {
            do
            {
                if let effectURL = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") {
                    
                    self.player = try AVAudioPlayer(contentsOf: effectURL)
                    self.player.play()
                    
                }
            }
            catch let error as NSError {
                print(error.description)
            }
        }
    }
    enum SoundEffect: String {
        case explosion = "explosion"
        case collision = "collision"
        case torpedo = "torpedo"
    }
    
    /********************************/
    /* Fulfilling scene delegate    */
    /********************************/
    /* We don't use any of this yet */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        targetingLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
//    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
//        // Create and configure a node for the anchor added to the view's session.
//        let labelNode = SKLabelNode(text: "👾")
//        labelNode.horizontalAlignmentMode = .center
//        labelNode.verticalAlignmentMode = .center
//        return labelNode;
//    }
//    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
