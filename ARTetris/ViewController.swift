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
		
		// Set the view's delegate
		sceneView.delegate = self
		
		// Create a new scene
		sceneView.scene = SCNScene()
		// Use default lighting
		sceneView.autoenablesDefaultLighting = true
		
		addGestures()
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
	
    private func getSessionConfiguration() -> ARConfiguration {
        if ARWorldTrackingConfiguration.isSupported {
			// Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
			configuration.planeDetection = .horizontal
			return configuration;
		} else {
			// Slightly less immersive AR experience due to lower end processor
            return AROrientationTrackingConfiguration()
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		// We need async execution to get anchor node's position relative to the root
		DispatchQueue.main.async {
			if let planeAnchor = anchor as? ARPlaneAnchor {
				// For a first detected plane
				if (self.tetris == nil) {
					// get center of the plane
					let x = planeAnchor.center.x + node.position.x
					let y = planeAnchor.center.y + node.position.y
					let z = planeAnchor.center.z + node.position.z
					// initialize Tetris with a well placed on this plane
					let config = TetrisConfig.standard
					let well = TetrisWell(config)
					let scene = TetrisScene(config, self.sceneView.scene, x, y, z)
					self.tetris = TetrisEngine(config, well, scene)
				}
			}
		}
	}
	
	private func addGestures() {
		let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
		swiftDown.direction = .down
		self.view.addGestureRecognizer(swiftDown)
		
		let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
		swiftUp.direction = .up
		self.view.addGestureRecognizer(swiftUp)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		self.view.addGestureRecognizer(tap)
	}
	
	@objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
		if (sender.direction == .down) {
			// drop down tetromino on swipe down
			tetris?.drop()
		} else {
			// rotate tetromino on swipe up
			tetris?.rotate()
		}
	}
	
	@objc private func handleTap(sender: UITapGestureRecognizer) {
		let location = sender.location(in: self.view)
		let x = location.x / self.view.bounds.size.width
		if (x < 0.5) {
			// move tetromino left on tap first 50% of the screen
			tetris?.left()
		} else {
			// move tetromino right on tap second 50% of the screen
			tetris?.right()
		}
	}
	
}
