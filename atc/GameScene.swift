//
//  GameScene.swift
//  atc
//
//  Created by Vincent Fumo on 9/8/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gameManager = DefaultGameManager()
    var lastFrameTime = TimeInterval(0)
    
    override func didMove(to view: SKView) {
        
    }

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastFrameTime
        if delta > 0.1 {
            lastFrameTime = currentTime
            // approx every 0.1 second...
            
            gameManager.update()
        }
    }
}
