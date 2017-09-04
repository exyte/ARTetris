# ARTetris
Augmented Reality Tetris made with ARKit and SceneKit.

# Demo
Click on the image below and check out the app demo:

<a href="https://youtu.be/DzYkvbS1nDE" target="_blank"><img src="http://i.imgur.com/BXi949y.jpg" width="600"></a>

# FAQ

> App crashes when running on iPhone 6, iPhone 5s, iPad Air, etc.

ARKit only works on devices with A9 chip or greater. So you need at least iPhone 6S or iPad with such a chip.

> App runs, but nothing happens.

To play the game you need to find some horizontal surface: floor, table top, etc. Point you camera to a plane and move your device a little bit in different directions to force ARKit to find bounds of the plane. Once it will be found, you will see Tetris well on this plane.

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
  * [Start](/ARTetris/TetrisEngine.swift#L102) game loop
  * [Handle](/ARTetris/TetrisEngine.swift#L32) gestures and change game state
  * [Handle animation](/ARTetris/TetrisEngine.swift#L94): stop game loop, execute animation, start game loop
* [TetrisScene](/ARTetris/TetrisScene.swift)
  * [Create](/ARTetris/TetrisScene.swift#L163) well frame
  * [Show](/ARTetris/TetrisScene.swift#L50) current tetromino
  * [Split](/ARTetris/TetrisScene.swift#L60) current tetromino into blocks and add to well
  * Animate [removal](/ARTetris/TetrisScene.swift#L74) of filled lines from scene
  * [Drop down](/ARTetris/TetrisScene.swift#L108) current tetromino
  * [Break up](/ARTetris/TetrisScene.swift#L117) blocks after game over using SceneKit physics

## Author

This project is maintained by [exyte](http://exyte.com). We design and build mobile and VR/AR applications.

## License

ARTetris is available under the MIT license. See the LICENSE file for more info.
