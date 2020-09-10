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
    var gameState: G.GameState
    
    let identService: IdentService
    
    init() {
        identService = DefaultIdentService()
        
        gameState = G.GameState.preActive
        planes = [Plane]()
        
        // load the board/game smarts
        
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: planeType)
        planes[0] = Plane(type: planeType, identifier: ident)
    }
    
    func update() {
        if gameState == G.GameState.active {
            for plane in planes {
                plane.update()
            }
        }
    }
}
