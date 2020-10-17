//
//  Plane.swift
//  atc
//
//  Created by Vincent Fumo on 9/9/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//
// plane should get 10 ticks per game clock
// queued commands are applied every tick
// alt changes every tick
// jet moves and updates direction every 5 ticks
// prop moves and updates direction every 10 ticks
//
// a "move" is one unit on the x,y axis
// an altitude change is set by `altDelta` which by default is 50' for prop, 100' for jet

import SpriteKit

class Plane: BaseSceneAware {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "planes")

    var planeLabel: SKLabelNode
    var planeSprite: SKSpriteNode

    var planeType: G.GameObjectType

    var currentAltitudeCommand: AltitudeCommand?
    var currentAltitude = 7000
    var desiredAltitude = 7000
    // the amount to change altitude on update (varies by plane type)
    let altDelta: Int
    var flightLevel = G.FlightLevel.STABLE

    var currentTurnCommand: TurnCommand?
    private var currentHeading = Direction.N
    private var desiredHeading = Direction.N

    private var destination: G.Destination
    private var destinationId: Character

    var boardLocX: Int
    var boardLocY: Int

    func getDestination() -> (G.Destination, Character) {
        return (destination, destinationId)
    }

    var flying = false
    var turning = false
    var updated = true
    var ignore = false
    var changingAltitude = false

    let boardScale: Int

    let ident: Character

    /**
            starttBoardX and startBoardY are the locations in board coordinates that the plane starts
     */
    init(type planeType: G.GameObjectType, heading: Direction, identifier: Character, flying: Bool, startBoardX: Int, startBoardY: Int, boardScale: Int, destination: G.Destination, destinationId: Character) {

        self.boardLocX = startBoardX
        self.boardLocY = startBoardY
        self.ident = identifier

        self.planeType = planeType
        self.flying = flying
        self.currentHeading = heading
        self.desiredHeading = heading
        self.planeType = planeType
        self.boardScale = boardScale
        self.destination = destination
        self.destinationId = destinationId

        var planeColor: NSColor
        if planeType == G.GameObjectType.JET {
            self.altDelta = 100
            planeColor = NSColor.systemRed
        } else {
            self.altDelta = 50
            planeColor = NSColor.systemGreen
        }

        let planeTexture = textureAtlas.textureNamed("plane3")

        let planeSpriteSize = CGSize(width: 53, height: 26)

        planeSprite = SKSpriteNode(texture: planeTexture, color: planeColor, size: planeSpriteSize)
        planeSprite.colorBlendFactor = 1.0
        planeSprite.alpha = 1.0
        planeSprite.zPosition = G.ZPos.plane
        planeSprite.anchorPoint = CGPoint(x: 0.22, y: 0.0)
//        planeSprite.physicsBody = SKPhysicsBody(circleOfRadius: 10)
//        planeSprite.physicsBody!.affectedByGravity = false
//        planeSprite.physicsBody!.allowsRotation = false
//        planeSprite.physicsBody!.isDynamic = false
//        planeSprite.physicsBody!.categoryBitMask = PhysicsCategory.plane.rawValue


        planeLabel = SKLabelNode(fontNamed: "Andale Mono")
        planeLabel.text = "\(ident)\(currentAltitude)"
        planeLabel.fontColor = NSColor.white
        planeLabel.fontSize = 14
        planeLabel.zPosition = G.ZPos.plane

        print("plane \(ident) starting at: \(boardLocX),\(boardLocY)")
    }

    override func initializeScene(scene: SKScene) {
        super.initializeScene(scene: scene)
        scene.addChild(planeSprite)
        scene.addChild(planeLabel)
    }

    func queueCommand(_ cmd: Command) {
        print("plane command queued: \(cmd)")

        if let alt = cmd as? AltitudeCommand {
            currentAltitudeCommand = alt
            updated = true
        } else if let _ = cmd as? MarkCommand {
            ignore = false
            updated = true
        } else if let _ = cmd as? IgnoreCommand {
            ignore = true
            updated = true
        } else if let _ = cmd as? UnmarkCommand {

            // TODO more to impl when we do Delayed commands
            ignore = true
            updated = true
        } else if let trn = cmd as? TurnCommand {
            currentTurnCommand = trn
            updated = true
        }
    }

    var ticks = 0

    func tick(clock: Bool) {
        ticks += 1

//        print("plane tick:\(ticks)")

//        if clock {
        startCommands()
//        }
        updateAltitude()

        if ticks % 2 == 0 {
            if planeType == G.GameObjectType.JET {
                movePlane()
                updateDirection()
            }
        }

        if ticks % 4 == 0 {
            if planeType == G.GameObjectType.PROP {
                movePlane()
                updateDirection()
            }
        }

        if updated {
            redrawSprite()
        }


        // TODO
        // check location of plane to see if it lands or moves off
        // or crashes. Check for 0 altitude also. Check also for
        // collision with another plane

    }

    func redrawSprite() {
        let (xVal, yVal) = Grid.convertToRadarCoords(gridX: boardLocX, gridY: boardLocY, gridScale: boardScale)

        //print("updatePlaneSprite \(sprite.ident): \(xVal), \(yVal)")

        planeSprite.position = CGPoint(x: xVal, y: yVal)
        planeLabel.position = CGPoint(x: xVal + 40, y: yVal + 25)
    }

    // start any queued commands
    func startCommands() {
        if let alt = currentAltitudeCommand {
            handleAltitudeCommand(alt)
        }

        if let trn = currentTurnCommand {
            handleTurnCommand(trn)
        }
    }

    func handleTurnCommand(_ trn: TurnCommand) {
        print("plane start turn")

        if trn.towards {
            // TODO
        } else {
            if let dir = trn.direction {
                if trn.left {
                    switch dir {
                    case Direction.NE:
                        self.desiredHeading = self.currentHeading.sub()
                    case Direction.NW:
                        self.desiredHeading = self.currentHeading.add()
                    default:
                        self.desiredHeading = self.currentHeading
                    }
                } else if trn.right {
                    switch dir {
                    case Direction.NE:
                        self.desiredHeading = self.currentHeading.add()
                    case Direction.NW:
                        self.desiredHeading = self.currentHeading.sub()
                    default:
                        self.desiredHeading = self.currentHeading
                    }
                } else {
                    self.desiredHeading = dir
                }
            }
        }

        self.currentTurnCommand = nil
    }

    func handleAltitudeCommand(_ alt: AltitudeCommand) {
        print("plane start alt adjust")

        if alt.climb {
            self.desiredAltitude = currentAltitude + alt.desiredAltitude!
        } else if alt.descend {
            self.desiredAltitude = currentAltitude - alt.desiredAltitude!
            if self.desiredAltitude < 0 {
                self.desiredAltitude = 0
            }
        } else {
            self.desiredAltitude = alt.desiredAltitude!
        }
        self.currentAltitudeCommand = nil
    }

    func getStatusLine() -> String {
        var dest: String
        if destination == G.Destination.Airport {
            dest = "A\(destinationId)"
        } else if destination == G.Destination.Exit {
            dest = "E\(destinationId)"
        } else if destination == G.Destination.Beacon {
            dest = "B\(destinationId)"
        } else {
            dest = ""
        }

        var cmd: String
        if turning {
            cmd = "\(desiredHeading.rawValue)"
        } else {
            cmd = ""
        }

        if ignore {
            cmd = "------"
        }

        return "\(ident)  \(currentAltitude)  \(dest)   \(cmd)"
    }

    func updateAltitude() {

        if desiredAltitude == currentAltitude {
            flightLevel = G.FlightLevel.STABLE
            return
        }

        if desiredAltitude > currentAltitude {
            flightLevel = G.FlightLevel.UP
            self.currentAltitude += altDelta
        } else if desiredAltitude < currentAltitude {
            flightLevel = G.FlightLevel.DOWN
            self.currentAltitude -= altDelta
        }

        planeLabel.text = "\(ident)\(currentAltitude)"
        updated = true
        print("plane \(ident) altitude changed to: \(currentAltitude)")

    }

    func updateDirection() {
        if flying {
            if desiredHeading != currentHeading {
                turning = true

                let numAddsClock = currentHeading.distance(to: desiredHeading)
                let numAddsCounter = currentHeading.distanceCounter(to: desiredHeading)

                var numAdds = 0

                // use more efficient route
                if (numAddsClock > numAddsCounter) {
                    numAdds = numAddsCounter
                    if numAdds > 2 {
                        numAdds = 2
                    }
                    currentHeading = currentHeading.sub(times: numAdds)
                } else {
                    numAdds = numAddsClock
                    if numAdds > 2 {
                        numAdds = 2
                    }
                    currentHeading = currentHeading.add(times: numAdds)
                }
            } else {
                turning = false
            }

            updated = true
        }
    }

    func movePlane() {
        if flying {
            switch currentHeading {
            case Direction.N:
                boardLocY += 1
            case Direction.S:
                boardLocY -= 1
            case Direction.E:
                boardLocX += 1
            case Direction.W:
                boardLocX -= 1
            case Direction.NE:
                boardLocY += 1
                boardLocX += 1
            case Direction.NW:
                boardLocY += 1
                boardLocX -= 1
            case Direction.SE:
                boardLocY -= 1
                boardLocX += 1
            case Direction.SW:
                boardLocY -= 1
                boardLocX -= 1
            }

            updated = true
            print("plane \(ident) moved to: \(boardLocX),\(boardLocY)")
        }
    }
}
