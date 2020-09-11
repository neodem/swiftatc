//
//  GameManager.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

protocol GameManager {
    func update()
}

class DefaultGameManager : GameManager {
    
    var planes: [Plane]
    var exits : [Exit]
    
    let planeDisplay: DisplayModule
    
    var gameState: G.GameState
    
    let identService: IdentService
    
    var boardScale: Int
    
    var time = 0
    var safe = 0
    
    init() {
        
        identService = DefaultIdentService()
        
        gameState = G.GameState.preActive
        planes = [Plane]()
        exits = [Exit]()
        
        let planeDisplayX = G.PlaneDisplay.x
        let planeDisplayY = G.PlaneDisplay.y - 34
        
        planeDisplay = DisplayModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY),x: planeDisplayX, y: planeDisplayY, rows: 12, cols: 25)
        planeDisplay.write(string: "TIME: \(time)", row: 0)
        planeDisplay.overWrite(string: "SAFE: \(safe)", row: 0, col: 11)
        
        // load the board/game smarts
        
        boardScale = 140
        
        // fake plane
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: planeType)
        let fakePlane = Plane(type: planeType, identifier: ident, flying: true, x: 140, y: 140)
        
        fakePlane.destination = G.Destination.Exit
        fakePlane.heading = G.Direction.SW
        
        planes.append(fakePlane)
        
        gameState = G.GameState.active
    }
    
    func getSprites() -> [SKSpriteNode] {
        var allSprites = [SKSpriteNode]()
        
        for plane in planes {
            if let sprite = plane.sprite {
                allSprites.append(sprite)
            }
        }
        
        for exit in exits {
            if let sprite = exit.sprite {
                allSprites.append(sprite)
            }
        }
        
        for displaySprite in planeDisplay.getSprites() {
            allSprites.append(displaySprite)
        }
        
        return allSprites
    }
    
    var actualTime = 0
    
    func update() {
        actualTime += 1
        if gameState == G.GameState.active {
            for plane in planes {
                plane.update()
                if plane.moved {
                    updatePlaneSprite(sprite: plane)
                    plane.moved = false
                }
            }
            
            if actualTime % 4 == 0 {
                time += 1
                planeDisplay.overWrite(string: "\(time)", row: 0, col: 7)
            }
            
        }
    }
    
    func updatePlaneSprite(sprite: BaseGameObject) {
        let xLoc = Float(sprite.locationX) / Float(boardScale)
        let yLoc = Float(sprite.locationY) / Float(boardScale)
        
        let xVal = ((G.Radar.xMax - G.Radar.xMin) * xLoc) + G.Radar.xMin
        let yVal = ((G.Radar.yMax - G.Radar.yMin) * yLoc) + G.Radar.yMin
        
        print("updatePlaneSprite \(sprite.ident): \(xVal), \(yVal)")
        
        sprite.sprite?.position = CGPoint(x: CGFloat(xVal), y: CGFloat(yVal))
    }
}
