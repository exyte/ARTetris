//
//  State.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/30/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

class TetrisState {
	
	static func random(_ width: Int, _ height: Int) -> TetrisState {
		return TetrisState(random(OneSidedTetromino.all.count), random(4), width / 2, height)
	}
	
	let index: Int
	let rotation: Int
	let x: Int
	let y: Int
	
	private init(_ index: Int, _ rotation: Int, _ x: Int, _ y: Int) {
		self.index = index
		self.rotation = rotation
		self.x = x
		self.y = y
	}
	
	func tetromino() -> FixedTetromino { return OneSidedTetromino.all[index].fixed[rotation] }
	
	func rotate() -> TetrisState { return TetrisState(index, (rotation + 1) % 4, x, y) }
	
	func left() -> TetrisState { return TetrisState(index, rotation, x - 1, y) }
	
	func right() -> TetrisState { return TetrisState(index, rotation, x + 1, y) }
	
	func down() -> TetrisState { return TetrisState(index, rotation, x, y - 1) }
	
	private static func random(_ max: Int) -> Int {
		return Int(arc4random_uniform(UInt32(max)))
	}
	
}
