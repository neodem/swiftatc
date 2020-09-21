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
        
        drawDisplay()
        initDisplayModules()
        
        setupTest()
        
        gameState = G.GameState.active
    }
    
    func drawDisplay() {
        let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "background")
        let mainDisplaySprite = SKSpriteNode(texture: textureAtlas.textureNamed("main-newnew"))
        mainDisplaySprite.size = CGSize(width: 1600, height: 1200)
        mainDisplaySprite.anchorPoint = .zero
        mainDisplaySprite.position = .zero
        mainDisplaySprite.zPosition = 50
        
        scene?.addChild(mainDisplaySprite)
    }
    
    func initDisplayModules() {
        planeDisplay.initialize(scene: scene!)
        scoreDisplay.initialize(scene: scene!)
        commandDisplay.initialize(scene: scene!)
        
        scoreDisplay.write(string: "TIME: \(gameClock)", row: 0)
        scoreDisplay.overWrite(string: "SAFE: \(safe)", row: 0, col: 11)
    }

    func setupTest() {
        self.boardScale = 140
        
        // load the board/game smarts
        
        // exits
        let exit0 = Exit(ident: "0", x: 70, y: 140, direction: Direction.S)
        exit0.initialize(scene: scene!)
        exits.append(exit0)
        
        let exit1 = Exit(ident: "1", x: 140, y: 140, direction: Direction.SW)
        exit1.initialize(scene: scene!)
        exits.append(exit1)
        
        let exit2 = Exit(ident: "2", x: 120, y: 0, direction: Direction.N)
        exit2.initialize(scene: scene!)
        exits.append(exit2)
        
        let exit3 = Exit(ident: "3", x: 0, y: 0, direction: Direction.NE)
        exit3.initialize(scene: scene!)
        exits.append(exit3)
        
        // fake plane
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: planeType)
        let fakePlane = Plane(type: planeType, heading: Direction.SW, destinationType: G.Destination.Exit, destinationId: "1", identifier: ident, flying: true, x: boardScale, y: boardScale)
        
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
                    updatePlaneSprite(sprite: plane, label: plane.planeLabel)
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
    
    func checkPlaneBounds(_ plane: Plane) {
        
    }
    
    // TODO move into the Plane class
    func updatePlaneSprite(sprite: BaseGameObject, label: SKLabelNode) {
        let xLoc = Float(sprite.locationX) / Float(boardScale)
        let yLoc = Float(sprite.locationY) / Float(boardScale)
        
        let xVal = ((G.Radar.xMax - G.Radar.xMin) * xLoc) + G.Radar.xMin
        let yVal = ((G.Radar.yMax - G.Radar.yMin) * yLoc) + G.Radar.yMin
        
        //print("updatePlaneSprite \(sprite.ident): \(xVal), \(yVal)")
        
        sprite.sprite?.position = CGPoint(x: CGFloat(xVal), y: CGFloat(yVal))
        label.position = CGPoint(x: CGFloat(xVal+50), y: CGFloat(yVal+30))
    }
}
