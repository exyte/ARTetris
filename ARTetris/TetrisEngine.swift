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
	var scores = 0
	
	init(_ scene: SCNScene, _ center: SCNVector3) {
		self.well = TetrisWell()
		self.scene = TetrisScene(scene, center, well)
		self.state = .random(well.width, well.height)
		self.scene.show(state)
		startTimer()
	}
	
	func rotate() { setState(state.rotate()) }
	
	func left() { setState(state.left()) }
	
	func right() { setState(state.right()) }
	
	func drop() {
		stopTimer()
		let initial = state
		while(!well.hasCollision(state.down())) {
			state = state.down()
		}
		let time = scene.drop(delta: initial.y - state.y, max: well.height)
		Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
			self.startTimer()
			self.mergeWell()
		}
	}
	
	private func setState(_ state: TetrisState) {
		if (!well.hasCollision(state)) {
			self.state = state
			scene.show(state)
		}
	}
	
	private func mergeWell() {
		well.merge(state)
		scene.merge(state)
		
		let rows = well.clearRows()
		if (rows.isEmpty) {
			nextTetromino()
		} else {
			self.stopTimer()
			let scores = getScores(rows.count)
			self.scores += scores
			let time = scene.removeRows(rows, scores)
			Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
				self.startTimer()
				self.nextTetromino()
			}
		}
	}
	
	private func getScores(_ rows: Int) -> Int {
		switch rows {
		case 1:
			return 100
		case 2:
			return 300
		case 3:
			return 500
		default:
			return 800
		}
	}
	
	private func nextTetromino() {
		state = .random(well.width, well.height)
		if (well.hasCollision(state)) {
			stopTimer()
			scene.destroy(self.scores)
		} else {
			scene.show(state)
		}
	}
	
	private func startTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			let down = self.state.down()
			if (self.well.hasCollision(down)) {
				self.mergeWell()
			} else {
				self.state = down
				self.scene.show(self.state)
			}
		}
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
}
