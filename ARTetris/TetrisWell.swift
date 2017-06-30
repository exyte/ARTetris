//
//  TetrisWell.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/29/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

class TetrisWell {
	
	let width = 10
	let height = 20
	
	var matrix: [[Bool]] = []

	init() {
		matrix.append([Bool](repeating: true, count: width + 2))
		for _ in 0...height+3 {
			addWellRow()
		}
	}
	
	public func hasCollision(_ state: TetrisState) -> Bool {
		let tetromino = state.tetromino()
		for i in 0...3 {
			if (matrix[state.y + tetromino.y(i)][state.x + tetromino.x(i)]) {
				return true
			}
		}
		return false
	}
	
	public func merge(_ state: TetrisState) {
		let tetromino = state.tetromino()
		for i in 0...3 {
			matrix[state.y + tetromino.y(i)][state.x + tetromino.x(i)] = true
		}
	}
	
	public func clearRows() -> [Int] {
		var toRemove: [Int] = []
		loop: for i in 1...height+1 {
			for j in 1...width {
				if (!matrix[i][j]) {
					continue loop
				}
			}
			toRemove.append(i)
		}
		toRemove.reverse()
		for i in toRemove {
			matrix.remove(at: i)
			addWellRow()
		}
		return toRemove
	}
	
	private func addWellRow() {
		var row = [Bool](repeating: false, count: width + 2)
		row[0] = true
		row[width + 1] = true
		matrix.append(row)
	}
	
}
