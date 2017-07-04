# ARTetris
Augmented Reality Tetris made with ARKit and SceneKit

[![ARTetris Demo](http://i.imgur.com/BXi949y.jpg)](https://youtu.be/DzYkvbS1nDE)

# Source Code Guide

* [ViewController](/ARTetris/ViewController.swift)
  * [Initialize](/ARTetris/ViewController.swift#L18) and [configure](/ARTetris/ViewController.swift#L32) ARKit
  * [Detect](/ARTetris/ViewController.swift#L56) horizontal plane and [initialize](/ARTetris/ViewController.swift#L63) Tetris game engine on this plane
  * Add [gesture recognizers](/ARTetris/ViewController.swift#L76) and [process](/ARTetris/ViewController.swift#L89) gestures
* [Tetromino](/ARTetris/Tetromino.swift): describe all tetrominos and their rotations
* [TetrisConfig](/ARTetris/TetrisConfig.swift): width and height of the well
* [TetrisState](/ARTetris/TetrisState.swift): tetris game state - current tetromino and its position in the well
* [TetrisWell](/ARTetris/TetrisWell.swift): well model describing filled cells
* [TetrisEngine](/ARTetris/TetrisEngine.swift): tetris game engine
  * [Start](/ARTetris/TetrisEngine.swift#102) game loop
  * [Handle](/ARTetris/TetrisEngine.swift#32) gestures and change game state
  * [Handle animation](/ARTetris/TetrisEngine.swift#94): stop game loop, execute animation, start game loop
* [TetrisScene](/ARTetris/TetrisScene.swift)
  * Create (addMarkers) well scene
  * Show (show) current tetromino
  * Split (addToWell) current tetromino to lines
  * Remove (removeLines) filled lines from scene
  * Drop down (drop) current tetromino
  * Break up blocks after game over using SceneKit physics
