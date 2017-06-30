//
//  Tetramino.swift
//  ARTetris
//
//  Created by Yuri Strot on 6/27/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

class OneSidedTetromino {
	
	static let all = [i, j, l, o, s, t, z]
	
	static let i = OneSidedTetromino(
		FixedTetromino([0, 1, 1, 1, 2, 1, 3, 1]),
		FixedTetromino([1, 0, 1, 1, 1, 2, 1, 3]))
	
	static let j = OneSidedTetromino([
		FixedTetromino([0, 1, 1, 1, 2, 1, 2, 0]),
		FixedTetromino([1, 0, 1, 1, 1, 2, 2, 2]),
		FixedTetromino([0, 1, 1, 1, 2, 1, 0, 2]),
		FixedTetromino([1, 0, 1, 1, 1, 2, 0, 0])])
	
	static let l = OneSidedTetromino([
		FixedTetromino([0, 1, 1, 1, 2, 1, 2, 2]),
		FixedTetromino([1, 0, 1, 1, 1, 2, 0, 2]),
		FixedTetromino([0, 1, 1, 1, 2, 1, 0, 0]),
		FixedTetromino([1, 0, 1, 1, 1, 2, 2, 0])])
	
	static let o = OneSidedTetromino(
		FixedTetromino([0, 0, 0, 1, 1, 0, 1, 1]))
	
	static let s = OneSidedTetromino(
		FixedTetromino([1, 0, 2, 0, 0, 1, 1, 1]),
		FixedTetromino([0, 0, 0, 1, 1, 1, 1, 2]))
	
	static let t = OneSidedTetromino([
		FixedTetromino([1, 0, 0, 1, 1, 1, 2, 1]),
		FixedTetromino([1, 0, 0, 1, 1, 1, 1, 2]),
		FixedTetromino([0, 1, 1, 1, 2, 1, 1, 2]),
		FixedTetromino([1, 0, 1, 1, 2, 1, 1, 2])])
	
	static let z = OneSidedTetromino(
		FixedTetromino([0, 0, 1, 0, 1, 1, 2, 1]),
		FixedTetromino([1, 0, 0, 1, 1, 1, 0, 2]))
	
	let fixed: [FixedTetromino]
	
	init(_ t: FixedTetromino) { self.fixed = [t, t, t, t] }
	
	init(_ t1: FixedTetromino, _ t2: FixedTetromino) { self.fixed = [t1, t2, t1, t2] }
	
	init(_ fixed: [FixedTetromino]) { self.fixed = fixed }
}

class FixedTetromino {
	
	let values: [Int]
	
	init(_ values: [Int]) { self.values = values }
	
	func x(_ index: Int) -> Int { return values[index * 2] }
	
	func y(_ index: Int) -> Int { return values[index * 2 + 1] }
	
}
