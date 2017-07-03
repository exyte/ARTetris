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
	
	private let cell: Float = 0.05
	
	private let colors : [UIColor] = [
		UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0),
		UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0),
		UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0),
		UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0),
		UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0),
		UIColor(red:0.20, green:0.67, blue:0.86, alpha:1.0),
		UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)]
	
	private let wellColor = UIColor.black
	private let scoresColor = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
	private let titleColor = UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0)
	
	private let config: TetrisConfig
	private let scene: SCNScene
	private let x: Float
	private let y: Float
	private let z: Float
	
	private var nodesByLines: [[SCNNode]] = []
	private var recent: SCNNode!
	private var well: SCNNode!
	
	init(_ config: TetrisConfig, _ scene: SCNScene, _ x: Float, _ y: Float, _ z: Float) {
		self.config = config
		self.scene = scene
		self.x = x
		self.y = y
		self.z = z
		self.well = self.addMarkers(config.width, config.height)
		scene.rootNode.addChildNode(self.well)
	}
	
	func show(_ current: TetrisState) {
		recent?.removeFromParentNode()
		recent = SCNNode()
		let tetromino = current.tetromino()
		for i in 0...3 {
			recent.addChildNode(newBox(current, tetromino.x(i), tetromino.y(i)))
		}
		scene.rootNode.addChildNode(recent)
	}
	
	func addToWell(_ current: TetrisState) {
		recent?.removeFromParentNode()
		let tetromino = current.tetromino()
		for i in 0...3 {
			let box = newBox(current, tetromino.x(i), tetromino.y(i))
			scene.rootNode.addChildNode(box)
			let row = tetromino.y(i) + current.y
			while(nodesByLines.count <= row) {
				nodesByLines.append([])
			}
			nodesByLines[row].append(box)
		}
	}
	
	func removeLines(_ lines: [Int], _ scores: Int) -> CFTimeInterval {
		let time = 0.2
		let opacity = CABasicAnimation(keyPath: "opacity")
		opacity.fromValue = 1
		opacity.toValue = 0
		opacity.duration = time
		opacity.fillMode = kCAFillModeForwards
		opacity.isRemovedOnCompletion = false
		for row in lines {
			for node in nodesByLines[row] {
				node.addAnimation(opacity, forKey: nil)
			}
		}
		Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
			self.addScores(lines.first!, scores)
			for (index, row) in lines.reversed().enumerated() {
				let nextRow = index + 1 < lines.count ? lines[index + 1] : self.nodesByLines.count
				if (nextRow > row + 1) {
					for j in row + 1..<nextRow {
						for node in self.nodesByLines[j] {
							let translate = CABasicAnimation(keyPath: "position.y")
							let y = self.y + Float(j) * self.cell
							translate.fromValue = y
							translate.toValue = y - self.cell * Float(index + 1)
							translate.duration = time
							translate.fillMode = kCAFillModeForwards
							translate.isRemovedOnCompletion = false
							node.addAnimation(translate, forKey: nil)
						}
					}
				}
			}
			for row in lines {
				for node in self.nodesByLines[row] {
					node.removeFromParentNode()
				}
				self.nodesByLines.remove(at: row)
			}
		}
		return time * 2
	}
	
	func drop(_ delta: Int) -> CFTimeInterval {
		let move = CABasicAnimation(keyPath: "position.y")
		move.fromValue = 0
		move.toValue = Float(-delta) * cell
		let percent = Double(delta - 1) / Double(config.height - 1)
		move.duration = percent * 0.3 + 0.1
		recent.addAnimation(move, forKey: nil)
		return move.duration
	}
	
	func showGameOver(_ scores: Int) {
		self.well.removeFromParentNode()
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
		Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
			self.addEndText(2, "Scores: \(scores)")
		}
	}
	
	private func addScores(_ row: Int, _ scores: Int) {
		let text = SCNText(string: "+\(scores)", extrusionDepth: 1)
		text.font = UIFont.systemFont(ofSize: 20)
		let textNode = SCNNode(geometry: text)
		
		let material = SCNMaterial()
		
		material.diffuse.contents = scoresColor
		text.materials = [material, material, material, material]
		
		let y = Float(row) * self.cell
		textNode.transform = SCNMatrix4Scale(SCNMatrix4Translate(self.translate(0, 0), 5 * cell, y, 2 * cell), 0.001, 0.001, 0.001)
		
		let translate = CABasicAnimation(keyPath: "position.y")
		translate.fromValue = textNode.transform.m42
		translate.toValue = textNode.transform.m42 + cell * 4
		translate.duration = 2
		translate.fillMode = kCAFillModeForwards
		translate.isRemovedOnCompletion = false
		textNode.addAnimation(translate, forKey: nil)
		
		let opacity = CABasicAnimation(keyPath: "opacity")
		opacity.fromValue = 1
		opacity.toValue = 0
		opacity.duration = 2
		opacity.fillMode = kCAFillModeForwards
		opacity.isRemovedOnCompletion = false
		textNode.addAnimation(opacity, forKey: nil)
		
		self.scene.rootNode.addChildNode(textNode)
	}
	
	private func addEndText(_ row: Int, _ text: String) {
		let text = SCNText(string: text, extrusionDepth: 1)
		text.font = UIFont.systemFont(ofSize: 20)
		text.containerFrame = CGRect(x: 0.0, y: 0.0, width: Double(10 * cell / 0.003), height: 150)
		text.alignmentMode = kCAAlignmentCenter
		let textNode = SCNNode(geometry: text)
		
		let material = SCNMaterial()
		material.diffuse.contents = titleColor
		text.materials = [material, material, material, material]
		
		let y = Float(row) * self.cell
		textNode.transform = SCNMatrix4Scale(SCNMatrix4Translate(self.translate(0, 0), 3 * cell, y, 0), 0.003, 0.003, 0.003)
		self.scene.rootNode.addChildNode(textNode)
	}
	
	private func addMarkers(_ width: Int, _ height: Int) -> SCNNode {
		let node = SCNNode()
		for i in 1...width + 1 {
			node.addChildNode(addLine(0.001, CGFloat(cell * Float(height+3)), 0.001, i, 0, 0))
			node.addChildNode(addLine(0.001, CGFloat(cell * Float(height+3)), 0.001, i, 0, 1))
		}
		for i in 0...height+3 {
			node.addChildNode(addLine(CGFloat(cell * Float(width)), 0.001, 0.001, 1, i, 0))
			node.addChildNode(addLine(CGFloat(cell * Float(width)), 0.001, 0.001, 1, i, 1))
		}
		for i in 1...width + 1 {
			for j in 0...height+3 {
				node.addChildNode(addLine(0.001, 0.001, CGFloat(cell), i, j, 1))
			}
		}
		return node
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
	
	private func addLine(_ w: CGFloat, _ h: CGFloat, _ l: CGFloat, _ x: Int, _ y: Int, _ z: Int) -> SCNNode {
		let box = SCNBox(width: w, height: h, length: l, chamferRadius: 0)
		let node = SCNNode(geometry: box)
		
		let material = SCNMaterial()
		material.diffuse.contents = wellColor
		material.transparency = 0.3
		box.materials = [material, material, material, material, material, material, material, material]
		
		// SCNPlanes are vertically oriented in their local coordinate space.
		// Rotate it to match the horizontal orientation of the ARPlaneAnchor.
		let shift = cell / Float(2)
		node.transform = SCNMatrix4Translate(translate(0, 0), cell * Float(x) + Float(w / CGFloat(2)) - shift, cell * Float(y) + Float(h / CGFloat(2)), cell * Float(z) + Float(-l / CGFloat(2)) - shift)
		
		// ARKit owns the node corresponding to the anchor, so make the plane a child node.
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
