//
//  GameManager.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import Foundation

protocol GameManager {
    func update()
}

class DefaultGameManager : GameManager {
    
    var planes: [Plane]
    var exits : [Exit]

    var gameState: G.GameState
    
    let identService: IdentService
    
    var boardScale: Int
    
    init() {
        identService = DefaultIdentService()
        
        gameState = G.GameState.preActive
        planes = [Plane]()
        exits = [Exit]()
        
        // load the board/game smarts
        
        boardScale = 14
        
        // fake plane
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: planeType)
        let fakePlane = Plane(type: planeType, identifier: ident, flying: true, x: 14, y: 14)
        
        fakePlane.destination = G.Destination.Exit
        fakePlane.heading = G.Direction.SW
        
        planes.append(fakePlane)
        
        gameState = G.GameState.active
    }
    
    func getDrawableGameObjects() -> [GameObject] {
        return planes + exits
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
