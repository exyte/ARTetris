//
//  ViewController.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/27/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	var tetris: TetrisEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		addSwipeRecognizer(direction: .down)
		addSwipeRecognizer(direction: .up)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		self.view.addGestureRecognizer(tap)
		
        // Set the view's delegate
        sceneView.delegate = self
		
        // Create a new scene
        let scene = SCNScene()
		
        // Set the scene to the view
		sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
		sceneView.scene.physicsWorld.gravity = SCNVector3Make(0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		// Run the view's session
		sceneView.session.run(getSessionConfiguration())
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
	
	private func getSessionConfiguration() -> ARSessionConfiguration {
		if ARWorldTrackingSessionConfiguration.isSupported {
			// Create a session configuration
			let configuration = ARWorldTrackingSessionConfiguration()
			configuration.planeDetection = .horizontal
			return configuration;
		} else {
			// slightly less immersive AR experience due to lower end processor
			return ARSessionConfiguration()
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		// async execution to get node relative to root
		DispatchQueue.main.async {
			if let planeAnchor = anchor as? ARPlaneAnchor {
				if (self.tetris == nil) {
					let x = planeAnchor.center.x + node.position.x
					let y = node.position.y
					let z = planeAnchor.center.z + node.position.z
					self.tetris = TetrisEngine(self.sceneView.scene, SCNVector3Make(x, y, z))
				}
			}
		}
	}
	
	@IBAction func didTapScreen(_ sender: UITapGestureRecognizer) {
	}
	
	private func addSwipeRecognizer(direction: UISwipeGestureRecognizerDirection) {
		let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
		swipe.direction = direction
		self.view.addGestureRecognizer(swipe)
	}
	
	@objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
		if (sender.direction == .down) {
			tetris?.fallDown()
		} else {
			tetris?.rotate()
		}
	}
	
	@objc private func handleTap(sender: UITapGestureRecognizer) {
		let location = sender.location(in: self.view)
		let size = self.view.bounds.size
		let x = location.x / size.width
		if (x < 0.5) {
			tetris?.moveLeft()
		} else {
			tetris?.moveRight()
		}
	}
	// MARK: - ARSCNViewDelegate
	
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
