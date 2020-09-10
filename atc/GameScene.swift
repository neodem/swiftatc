//
//  GameScene.swift
//  atc
//
//  Created by Vincent Fumo on 9/8/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

enum GameState {
    case active, preActive
}

class GameScene: SKScene {
    
    let planes = [Plane]()
    var gameState = GameState.preActive
    
    override func didMove(to view: SKView) {
        
    }
    
    var lastFrameTime = TimeInterval(0)
    
    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastFrameTime
        if delta > 0.1 {
            lastFrameTime = currentTime
            // approx every 0.1 second...
            
            if gameState == GameState.active {
                for plane in planes {
                    plane.update()
                }
            }
            
        }
    }
}
