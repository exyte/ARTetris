//
//  TetrisEngine.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/30/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation
import SceneKit

class TetrisEngine {
	
	let well: TetrisWell
	let scene: TetrisScene
	
	var state: TetrisState
	var timer: Timer?
	
	init(_ scene: SCNScene, _ center: SCNVector3) {
		self.well = TetrisWell()
		self.scene = TetrisScene(scene, center, well)
		self.state = .random(well.width, well.height)
		self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			self.dropDown()
		}
		self.scene.show(state)
	}
	
	func rotate() {
		trySetState(state.rotate())
	}
	
	func moveLeft() {
		trySetState(state.left())
	}
	
	func moveRight() {
		trySetState(state.right())
	}
	
	func fallDown() {
		while(!well.hasCollision(state.down())) {
			state = state.down()
		}
		mergeWell()
	}
	
	@discardableResult private func trySetState(_ state: TetrisState) -> Bool {
		if (!well.hasCollision(state)) {
			self.state = state
			scene.show(state)
			return true
		}
		return false
	}
	
	private func dropDown() {
		if (!trySetState(state.down())) {
			mergeWell()
		}
	}
	
	private func mergeWell() {
		well.merge(state)
		scene.merge(state)
		
		scene.removeRows(well.clearRows())
		
		state = .random(well.width, well.height)
		if (well.hasCollision(state)) {
			self.timer?.invalidate()
			self.timer = nil
			scene.destroy()
		} else {
			scene.show(state)
		}
	}
	
}
