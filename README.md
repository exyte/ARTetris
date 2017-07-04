# ARTetris
Augmented Reality Tetris made with ARKit and SceneKit.

# Demo
Click on the image below and check out the app demo:

<a href="https://youtu.be/DzYkvbS1nDE"><img src="http://i.imgur.com/BXi949y.jpg" width="600"></a>

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

This project is maintained by the [exyte](http://www.exyte.com) company, a team of experienced software engineers from the cold Siberia. We don't have bears and don't like vodka, but we love to create great applications! Just [contact us](mailto:info@exyte.com).

## License

ARTetris is available under the MIT license. See the LICENSE file for more info.
