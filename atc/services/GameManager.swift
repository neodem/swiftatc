//
//  GameManager.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

protocol GameManager {
    func tick()
    func initialize(scene: SKScene)
}

class DefaultGameManager : GameManager {
    
    let identService: IdentService
    var planes: [Plane]
    var exits : [Exit]
    var gameState: G.GameState
    var boardScale = 0
    var gameClock = 0
    var safe = 0
    var scene: SKScene?
    
    var planeDisplay: PlaneDisplayModule
    var scoreDisplay: DisplayModule
    var commandDisplay: CommandModule
    
    var commandToDispatch: Command?
    
    init() {
        identService = DefaultIdentService()
        planes = [Plane]()
        exits = [Exit]()
        gameState = G.GameState.preActive
        
        planeDisplay = PlaneDisplayModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY),x: G.PlaneDisplay.x, y: G.PlaneDisplay.y - G.LetterSize.height, rows: 12, cols: 25)
        
        scoreDisplay = DisplayModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY),x: G.ScoreDisplay.x, y: G.ScoreDisplay.y - G.LetterSize.height, rows: 3, cols: 25)
        
        commandDisplay = CommandModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY),x: G.CommandDisplay.x, y: G.CommandDisplay.y - G.LetterSize.height, rows: 3, cols: 75)
        
    }
    
    public func handleKey(_ key: Key) {
        // will return a valid command if command is complete, else nil
        commandToDispatch = commandDisplay.inputKey(key)
    }
    
    func initialize(scene: SKScene) {
        self.scene = scene
        
        setupTest()
        
        gameState = G.GameState.active
    }
    
    func setupTest() {
        boardScale = 140
        
        planeDisplay.initialize(scene: scene!)
        scoreDisplay.initialize(scene: scene!)
        commandDisplay.initialize(scene: scene!)
        
        scoreDisplay.write(string: "TIME: \(gameClock)", row: 0)
        scoreDisplay.overWrite(string: "SAFE: \(safe)", row: 0, col: 11)
        
        // load the board/game smarts
        
        // fake plane
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: planeType)
        let fakePlane = Plane(type: planeType, heading: Direction.SW, destinationType: G.Destination.Exit, destinationId: "1", identifier: ident, flying: true, x: 140, y: 140)
        
        fakePlane.initialize(scene: scene!)
        planes.append(fakePlane)
        
        planeDisplay.addPlane(plane: fakePlane)
    }
    
    var ticks = 0
    func tick() {
        ticks += 1
        if gameState == G.GameState.active {
            for plane in planes {
                if let cmd = commandToDispatch {
                    if cmd.ident == plane.ident {
                        plane.command(cmd)
                        commandToDispatch = nil
                    }
                }
                
                plane.tick()
                if plane.updated {
                    updatePlaneSprite(sprite: plane)
                    planeDisplay.updatePlane(plane: plane)
                    plane.updated = false
                }
            }
            
            if ticks % 60 == 0 {
                gameClock += 1
                print("clock: \(gameClock)")
                scoreDisplay.overWrite(string: "\(gameClock)", row: 0, col: 6)
            }
            
        }
    }
    
    func updatePlaneSprite(sprite: BaseGameObject) {
        let xLoc = Float(sprite.locationX) / Float(boardScale)
        let yLoc = Float(sprite.locationY) / Float(boardScale)
        
        let xVal = ((G.Radar.xMax - G.Radar.xMin) * xLoc) + G.Radar.xMin
        let yVal = ((G.Radar.yMax - G.Radar.yMin) * yLoc) + G.Radar.yMin
        
        //print("updatePlaneSprite \(sprite.ident): \(xVal), \(yVal)")
        
        sprite.sprite?.position = CGPoint(x: CGFloat(xVal), y: CGFloat(yVal))
    }
}
