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
    
    init() {
        
        identService = DefaultIdentService()
        
        gameState = G.GameState.preActive
        planes = [Plane]()
        exits = [Exit]()
        
        planeDisplay = DisplayModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY), x: 900, y: 900, rows: 12, cols: 25)
        planeDisplay.write(string: "HELLO", row: 0)
        
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
    
    func update() {
        if gameState == G.GameState.active {
            for plane in planes {
                plane.update()
                if plane.moved {
                    updatePlaneSprite(sprite: plane)
                    plane.moved = false
                }
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
