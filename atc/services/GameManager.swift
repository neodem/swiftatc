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
    var planes: [Character : Plane]
    var exits : [Character : Exit]
    var gameState: G.GameState
    var boardScale = 0
    
    var safe = 0
    var scene: SKScene?
    
    var planeDisplay: PlaneDisplayModule
    var scoreDisplay: DisplayModule
    var commandDisplay: CommandModule
    
    var commandToDispatch: Command?
    
    init() {
        identService = DefaultIdentService()
        planes = [Character : Plane]()
        exits = [Character : Exit]()
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
    
    func drawDot(x: Float, y: Float, scene: SKScene, color: NSColor) {
        let dot = SKSpriteNode(color: NSColor.systemYellow, size: CGSize(width: 2, height: 2))
        dot.colorBlendFactor = 1.0
        dot.alpha = 0.5
        dot.zPosition = G.ZPos.debug
        dot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        dot.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        //        let dotdot = SKSpriteNode(color: NSColor.systemRed, size: CGSize(width: 1, height: 1))
        //        dotdot.colorBlendFactor = 1.0
        //        dotdot.alpha = 1.0
        //        dotdot.zPosition = 1001
        //        dotdot.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        //        dot.addChild(dotdot)
        
        scene.addChild(dot)
    }
    
    func setupTest() {
        
        // test dots for radar bounds
//        drawDot(x: G.Radar.xMin, y: G.Radar.yMin, scene: scene!, color: NSColor.systemYellow)
//        drawDot(x: G.Radar.xMin, y: G.Radar.yMax, scene: scene!, color: NSColor.systemYellow)
//        drawDot(x: G.Radar.xMax, y: G.Radar.yMin, scene: scene!, color: NSColor.systemYellow)
//        drawDot(x: G.Radar.xMax, y: G.Radar.yMax, scene: scene!, color: NSColor.systemYellow)
        
        self.boardScale = 150
        
        // load the board/game smarts
        
        // exits
        let exit0 = Exit(ident: "0", x: boardScale/2, y: boardScale, direction: Direction.N, gridScale: boardScale)
        exit0.initialize(scene: scene!)
        exits["0"] = exit0
        
        let exit1 = Exit(ident: "1", x: boardScale, y: boardScale, direction: Direction.NE, gridScale: boardScale)
        exit1.initialize(scene: scene!)
        exits["1"] = exit1
        
        let exit2 = Exit(ident: "2", x: boardScale, y: boardScale/2, direction: Direction.E, gridScale: boardScale)
        exit2.initialize(scene: scene!)
        exits["2"] = exit2
        
        let exit3 = Exit(ident: "3", x: boardScale, y: 0, direction: Direction.SE, gridScale: boardScale)
        exit3.initialize(scene: scene!)
        exits["3"] = exit3
        
        let exit4 = Exit(ident: "4", x: boardScale/2, y: 0, direction: Direction.S, gridScale: boardScale)
        exit4.initialize(scene: scene!)
        exits["4"] = exit4
        
        let exit5 = Exit(ident: "5", x: 0, y: 0, direction: Direction.SW, gridScale: boardScale)
        exit5.initialize(scene: scene!)
        exits["5"] = exit5
        
        let exit6 = Exit(ident: "6", x: 0, y: boardScale/2, direction: Direction.W, gridScale: boardScale)
        exit6.initialize(scene: scene!)
        exits["6"] = exit6
        
        let exit7 = Exit(ident: "7", x: 0, y: boardScale, direction: Direction.NW, gridScale: boardScale)
        exit7.initialize(scene: scene!)
        exits["7"] = exit7

//        let exit8 = Exit(ident: "8", x: 135, y: boardScale, direction: Direction.N, gridScale: boardScale)
//        exit8.initialize(scene: scene!)
//        exits["8"] = exit8
        
        // fake plane
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: planeType)
        let fakePlane = Plane(type: planeType, heading: Direction.N, identifier: ident, flying: true, x: boardScale/2, y: boardScale-20, boardScale: boardScale, destination: G.Destination.Exit, destinationId: "8")
        
        fakePlane.initialize(scene: scene!)
        planes[fakePlane.ident] = fakePlane
        planeDisplay.addPlane(plane: fakePlane)
    }
    
    var ticks = 0
    var gameClock = 0
    
    // called by GameScene every 0.1s
    func tick() {
        ticks += 1
        //        print("tick:\(ticks)")
        
        if gameState == G.GameState.active {
            
            var clock = false
            
            // every 5s the game clock advances
            if ticks % 50 == 0 {
                gameClock += 1
                clock = true
                print("clock: \(gameClock)")
                scoreDisplay.overWrite(string: "\(gameClock)", row: 0, col: 6)
            }
            
            // on every tick, if there is a command to dispatch, we send it to the plane's queue
            if let cmd = commandToDispatch {
                if let planeForCommand = planes[cmd.ident] {
                    planeForCommand.queueCommand(cmd)
                }
                
                commandToDispatch = nil
            }
            
            // every 0.5s the the planes get a tick (1/10 of the game clock rate)
            if ticks % 5 == 0 {
                for (_,plane) in planes {
                    plane.tick(clock: clock)
                    
                    if plane.updated {
                        planeDisplay.updatePlane(plane: plane)
                        plane.updated = false
                    }
                }
                
                // after all planes moved, we check their state.. have they crashed? did they exit/land ok?
                
                // lets see if they accomplised their goal. If so, we remove them and update the
                // score and the planeDisplay
                for (_,plane) in planes {
                    let (destination, destinationId) = plane.getDestination()
                    if destination == G.Destination.Airport {
                        //TODO not implemented yet
                    } else if destination == G.Destination.Exit {
                        if let exit = exits[destinationId] {
                            if exit.inExit(sprite: plane.planeSprite) {
                                if plane.currentAltitude == 9000 {
                                    print("plane \(plane.ident) exited")
                                    safe += 1
                                    scoreDisplay.overWrite(string: "SAFE: \(safe)", row: 0, col: 11)
                                    planeDisplay.removePlane(ident: plane.ident)
                                    plane.planeSprite.removeFromParent()
                                    plane.planeLabel.removeFromParent()
                                    planes[plane.ident] = nil
                                }
                            }
                        }
                    }
                }
                
                // did the any of the remaining planes crash in any way?
                //                for (_,plane) in planes {
                //                }
            }
        }
    }
    
}
