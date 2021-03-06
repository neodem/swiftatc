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

class DefaultGameManager: GameManager {

    let identService: IdentService
    var planes: [Character: Plane]
    var exits: [Character: Exit]
    var airports: [Character: Airport]
    var gameState: G.GameState
    var boardScale = 0

    var safe = 0
    var scene: SKScene?

    var planeDisplay: PlaneDisplayModule
    var scoreDisplay: DisplayModule
    var commandDisplay: CommandModule

    var commandToDispatch: Command?

    var ticks = 0
    var gameClock = 0

    var gameMode: GameName

    var chanceOfNewPlane: Float = 0.0
    var chanceOfStartingAtAirport: Float = 0.0
    var chanceLandAtAirport: Float = 0.0

    init() {
        identService = DefaultIdentService()
        planes = [Character: Plane]()
        exits = [Character: Exit]()
        airports = [Character: Airport]()
        gameState = G.GameState.preActive

        gameMode = GameName.EASY

        planeDisplay = PlaneDisplayModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY), x: G.PlaneDisplay.x, y: G.PlaneDisplay.y - G.LetterSize.height, rows: 12, cols: 25)
        scoreDisplay = DisplayModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY), x: G.ScoreDisplay.x, y: G.ScoreDisplay.y - G.LetterSize.height, rows: 3, cols: 25)
        commandDisplay = CommandModule(ident: identService.getIdent(type: G.GameObjectType.DISPLAY), x: G.CommandDisplay.x, y: G.CommandDisplay.y - G.LetterSize.height, rows: 3, cols: 75)
    }

    public func handleKey(_ key: Key) {
        // will return a valid command if command is complete, else nil
        commandToDispatch = commandDisplay.inputKey(key)
    }

    func initialize(scene: SKScene) {
        self.scene = scene

        drawDisplay()
        initDisplayModules()
        setupGame()

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

    func setupEasy() {
        self.boardScale = 150
        self.chanceOfNewPlane = 0.07
        self.chanceOfStartingAtAirport = 0.20
        self.chanceLandAtAirport = 0.20

        // exits
        exits["0"] = Exit(ident: "0", boardX: 75, boardY: 150, direction: Direction.N, gridScale: boardScale)
        exits["1"] = Exit(ident: "1", boardX: 150, boardY: 150, direction: Direction.NE, gridScale: boardScale)
        exits["2"] = Exit(ident: "2", boardX: 125, boardY: 0, direction: Direction.SE, gridScale: boardScale)
        exits["3"] = Exit(ident: "3", boardX: 0, boardY: 0, direction: Direction.SW, gridScale: boardScale)

        // 1 airport
        airports["0"] = Airport(ident: "0", boardX: 75, boardY: 65, direction: Direction.N, gridScale: boardScale)
    }

    func setupTest() {

        self.boardScale = 150
        self.chanceOfNewPlane = 0.00
        self.chanceOfStartingAtAirport = 0.20
        self.chanceLandAtAirport = 1.00

        // test dots for radar bounds
//        drawDot(x: G.Radar.xMin, y: G.Radar.yMin, scene: scene!, color: NSColor.systemYellow)
//        drawDot(x: G.Radar.xMin, y: G.Radar.yMax, scene: scene!, color: NSColor.systemYellow)
//        drawDot(x: G.Radar.xMax, y: G.Radar.yMin, scene: scene!, color: NSColor.systemYellow)
//        drawDot(x: G.Radar.xMax, y: G.Radar.yMax, scene: scene!, color: NSColor.systemYellow)

        self.boardScale = 150

        // load the board/game smarts

        // exits
        exits["0"] = Exit(ident: "0", boardX: 75, boardY: 150, direction: Direction.N, gridScale: boardScale)
        exits["1"] = Exit(ident: "1", boardX: 150, boardY: 150, direction: Direction.NE, gridScale: boardScale)
        exits["2"] = Exit(ident: "2", boardX: 125, boardY: 0, direction: Direction.SE, gridScale: boardScale)
        exits["3"] = Exit(ident: "3", boardX: 0, boardY: 0, direction: Direction.SW, gridScale: boardScale)

        // 1 airport
        airports["1"] = Airport(ident: "1", boardX: 75, boardY: 65, direction: Direction.N, gridScale: boardScale)

        // fake plane
        let planeType = G.GameObjectType.PROP
        let ident = identService.getIdent(type: G.GameObjectType.PLANE)
        let testPlane = Plane(type: planeType, heading: Direction.N, identifier: ident, flying: true, startBoardX: 75, startBoardY: 45, boardScale: boardScale, destination: G.Destination.Airport, destinationId: "1")
        testPlane.currentAltitude = 1000
        testPlane.desiredAltitude = 1000
        testPlane.initializeScene(scene: scene!)
        planeDisplay.addPlane(plane: testPlane)
        planes[ident] = testPlane
    }

    // called by GameScene every 0.1s
    func tick() {
        ticks += 1
        //        print("tick:\(ticks)")

        if gameState == G.GameState.active {

            var advanceGameClock = false

            // every 5s the game clock advances
            if ticks % 50 == 0 {
                gameClock += 1
                advanceGameClock = true
                print("clock: \(gameClock)")
                scoreDisplay.overWrite(string: "\(gameClock)", row: 0, col: 6)

                if Float.random(in: 0..<1) < chanceOfNewPlane {
                    addNewPlane()
                }
            }

            // on every tick, if there is a command to dispatch, we send it to the plane's queue
            dispatchCommand()

            // every 0.5s the the planes get a tick (1/10 of the game clock rate)
            if ticks % 5 == 0 {
                movePlanes(advanceGameClock: advanceGameClock)

                // after all planes moved, we check their state.. have they crashed? did they exit/land ok?

                // lets see if they accomplished their goal. If so, we remove them and update the
                // score and the planeDisplay
                checkPlaneGoals()

                // did the any of the remaining planes crash in any way? (into each other, altitude too low?)
                checkPlaneCollisions()

                checkPlaneAtWrongExit()

                checkPlaneOutOfBounds()
            }
        }
    }

    private func checkPlaneCollisions() {
        for (_, plane) in planes {
            if !plane.immune {
                //todo
            }
        }
    }

    private func checkPlaneOutOfBounds() {
        // todo
    }

    private func checkPlaneAtWrongExit() {
        for (_, plane) in planes {
            if !plane.immune {
                // check all exits
                for (_, exit) in exits {
                    if exit.inExit(sprite: plane.planeSprite) {
                        let msg = "plane \(plane.ident) exited at the incorrect destination!"
                        print(msg)
                        gameState = G.GameState.incorrectlyExited
                        commandDisplay.write(string: msg, row: 2)
                    }
                }
            }
        }
    }

    private func checkPlaneGoals() {
        for (_, plane) in planes {
            if !plane.immune {
                let (destination, destinationId) = plane.getDestination()

                if destination == G.Destination.Airport {
                    let destinationAirport = airports[destinationId]
                    if destinationAirport != nil && destinationAirport!.inAirport(sprite: plane.planeSprite) {
                        if plane.currentAltitude < 1000 {
                            print("plane \(plane.ident) landed")
                            safe += 1
                            scoreDisplay.overWrite(string: "SAFE: \(safe)", row: 0, col: 11)
                            planeDisplay.removePlane(ident: plane.ident)
                            plane.planeSprite.removeFromParent()
                            plane.planeLabel.removeFromParent()
                            planes[plane.ident] = nil
                        }
                    }
                } else if destination == G.Destination.Exit {
                    let destinationExit = exits[destinationId]
                    if destinationExit != nil && destinationExit!.inExit(sprite: plane.planeSprite) {
                        if plane.currentAltitude == 9000 {
                            print("plane \(plane.ident) exited")
                            safe += 1
                            scoreDisplay.overWrite(string: "SAFE: \(safe)", row: 0, col: 11)
                            planeDisplay.removePlane(ident: plane.ident)
                            plane.planeSprite.removeFromParent()
                            plane.planeLabel.removeFromParent()
                            planes[plane.ident] = nil
                        } else {
                            let msg = "plane \(plane.ident) exited at an incorrect altitude: \(plane.currentAltitude)"
                            print(msg)
                            gameState = G.GameState.incorrectlyExited
                            commandDisplay.write(string: msg, row: 2)
                        }
                    }
                }
            }
        }
    }

    private func movePlanes(advanceGameClock: Bool) {
        for (_, plane) in planes {
            plane.tick(clock: advanceGameClock)

            if plane.updated {
                planeDisplay.updatePlane(plane: plane)
                plane.updated = false
            }
        }
    }

    private func dispatchCommand() {
        if let cmd = commandToDispatch {
            if let planeForCommand = planes[cmd.ident] {
                planeForCommand.queueCommand(cmd)
            }

            commandToDispatch = nil
        }
    }

    private func setupGame() {
        switch gameMode {
        case GameName.EASY:
            setupEasy()
        case GameName.TEST:
            setupTest()
        default:
            setupTest()
        }

        for (_, exit) in exits {
            exit.initializeScene(scene: scene!)
        }

        for (_, airport) in airports {
            airport.initializeScene(scene: scene!)
        }

        if gameMode != GameName.TEST {
            addNewPlane()
        }
    }

// maybe we add a new plane
    private func addNewPlane() {
        let planeType = randomPlaneType()

        // TODO ADD a start at an airport
        let entry = chooseRandomExit()
        let entryX = exits[entry]!.boardX
        let entryY = exits[entry]!.boardY
        let heading = exits[entry]!.direction.opposite()

        var destinationType = G.Destination.Exit
        var dest = chooseRandomExit(not: entry)
        if Float.random(in: 0..<1) < chanceLandAtAirport {
            destinationType = G.Destination.Airport
            dest = chosseRandomAirport(not: entry)
        }
        let destId = Character("\(dest)")

        let ident = identService.getIdent(type: G.GameObjectType.PLANE)
        let newPlane = Plane(type: planeType, heading: heading, identifier: ident, flying: true, startBoardX: entryX, startBoardY: entryY, boardScale: boardScale, destination: destinationType, destinationId: destId)

        planes[ident] = newPlane
        newPlane.initializeScene(scene: scene!)
        planeDisplay.addPlane(plane: newPlane)

    }

    private func chooseRandomExit() -> Character {
        let charint = Int.random(in: 0..<exits.count)
        return Character("\(charint)")
    }

    private func chooseRandomExit(not: Character) -> Character {
        var result = chooseRandomExit()
        while result == not {
            result = chooseRandomExit()
        }

        return result
    }

    private func chosseRandomAirport() -> Character {
        let charint = Int.random(in: 0..<airports.count)
        return Character("\(charint)")
    }

    private func chosseRandomAirport(not: Character) -> Character {
        var result = chosseRandomAirport()
        while result == not {
            result = chosseRandomAirport()
        }

        return result
    }

    private func randomPlaneType() -> G.GameObjectType {
        if Bool.random() {
            return G.GameObjectType.JET
        }
        return G.GameObjectType.PROP
    }

}
