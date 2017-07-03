//
//  TetrisWell.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/29/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

/** Tetris well model */
class TetrisWell {
	
	private let config: TetrisConfig
	private var matrix: [[Bool]] = []

	init(_ config: TetrisConfig) {
		self.config = config
		matrix.append([Bool](repeating: true, count: config.width + 2))
		for _ in 0...config.height + 3 {
			addLine()
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
	
	public func add(_ current: TetrisState) {
		let tetromino = current.tetromino()
		for i in 0...3 {
			matrix[current.y + tetromino.y(i)][current.x + tetromino.x(i)] = true
		}
	}
	
	public func clearFilledLines() -> [Int] {
		var toRemove: [Int] = []
		loop: for i in 1...config.height + 1 {
			for j in 1...config.width {
				if (!matrix[i][j]) {
					continue loop
				}
			}
			toRemove.append(i)
		}
		toRemove.reverse()
		for i in toRemove {
			matrix.remove(at: i)
			addLine()
		}
		return toRemove
	}
	
	private func addLine() {
		var row = [Bool](repeating: false, count: config.width + 2)
		row[0] = true
		row[config.width + 1] = true
		matrix.append(row)
	}
	
}
