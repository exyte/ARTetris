//
//  TetrisScene.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/29/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation
import SceneKit

class TetrisScene {
	
	let cell : Float = 0.05
	let colors : [UIColor] = [.cyan, .blue, .orange, .yellow, .green, .purple, .red]
	
	let scene: SCNScene
	let x: Float
	let y: Float
	let z: Float
	
	var nodesByLines: [[SCNNode]] = []
	var recent: SCNNode!
	
	init(_ scene: SCNScene, _ center: SCNVector3, _ well: TetrisWell) {
		self.scene = scene
		self.x = center.x
		self.y = center.y
		self.z = center.z
		addMarkers(well.width)
	}
	
	func show(_ state: TetrisState) {
		recent?.removeFromParentNode()
		recent = SCNNode()
		let tetromino = state.tetromino()
		for i in 0...3 {
			recent.addChildNode(newBox(state, tetromino.x(i), tetromino.y(i)))
		}
		scene.rootNode.addChildNode(recent)
	}
	
	func merge(_ state: TetrisState) {
		recent?.removeFromParentNode()
		let tetromino = state.tetromino()
		for i in 0...3 {
			let box = newBox(state, tetromino.x(i), tetromino.y(i))
			scene.rootNode.addChildNode(box)
			let row = tetromino.y(i) + state.y
			while(nodesByLines.count <= row) {
				nodesByLines.append([])
			}
			nodesByLines[row].append(box)
		}
	}
	
	func removeRows(_ rows: [Int]) {
		for row in rows {
			for node in nodesByLines[row] {
				node.removeFromParentNode()
			}
			for j in row + 1..<nodesByLines.count {
				for node in nodesByLines[j] {
					node.transform = SCNMatrix4Translate(node.transform, 0, -cell, 0)
				}
			}
			nodesByLines.remove(at: row)
		}
	}
	
	func destroy() {
		addFloor()
		scene.physicsWorld.gravity = SCNVector3Make(0, -2, 0)
		for i in 0..<nodesByLines.count {
			let z = Float((Int(arc4random_uniform(3)) - 1) * i) * -0.01
			let x = Float((Int(arc4random_uniform(3)) - 1) * i) * -0.01
			let direction = SCNVector3Make(x, 0, z)
			for item in nodesByLines[i] {
				item.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
				item.physicsBody?.angularDamping = 0.9
				item.physicsBody?.applyForce(direction, asImpulse: true)
			}
		}
	}
	
	private func addMarkers(_ width: Int) {
		for i in 1...width {
			addMarker(i, 0)
		}
	}
	
	private func newBox(_ state: TetrisState, _ x: Int, _ y: Int) -> SCNNode {
		let box = SCNBox(width: CGFloat(cell), height: CGFloat(cell), length: CGFloat(cell), chamferRadius: 0.005)
		let node = SCNNode(geometry: box)
		node.transform = SCNMatrix4Translate(translate(state.x, state.y), Float(x) * cell, Float(y) * cell - cell / 2, 0)
		
		let material = SCNMaterial()
		material.diffuse.contents = colors[state.index]
		box.materials = [material, material, material, material, material, material]
		return node
	}
	
	private func addMarker(_ x: Int, _ y: Int) {
		let plane = SCNPlane(width: 0.045, height: 0.045)
		let planeNode = SCNNode(geometry: plane)
		
		let material = SCNMaterial()
		material.diffuse.contents = UIColor.gray
		material.transparency = 0.3
		plane.materials = [material, material]
		
		// SCNPlanes are vertically oriented in their local coordinate space.
		// Rotate it to match the horizontal orientation of the ARPlaneAnchor.
		let matrix = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
		planeNode.transform = SCNMatrix4Mult(matrix, translate(x, y))
		
		// ARKit owns the node corresponding to the anchor, so make the plane a child node.
		scene.rootNode.addChildNode(planeNode)
	}
	
	private func addFloor() {
		let size : CGFloat = 10
		let plane = SCNPlane(width: size, height: size)
		let planeNode = SCNNode(geometry: plane)
		
		let material = SCNMaterial()
		material.diffuse.contents = UIColor.gray
		material.transparency = 0
		plane.materials = [material, material]
		
		// SCNPlanes are vertically oriented in their local coordinate space.
		// Rotate it to match the horizontal orientation of the ARPlaneAnchor.
		let matrix = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
		planeNode.transform = SCNMatrix4Mult(matrix, translate(0, 0))
		planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
		planeNode.physicsBody?.friction = 1
		scene.rootNode.addChildNode(planeNode)
	}
	
	private func translate(_ x: Int, _ y: Int) -> SCNMatrix4 {
		return SCNMatrix4MakeTranslation(self.x + Float(x) * cell, self.y + Float(y) * cell + cell / 2, self.z)
	}
	
}
