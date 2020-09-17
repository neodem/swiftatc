//
//  Plane.swift
//  atc
//
//  Created by Vincent Fumo on 9/9/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Plane: BaseGameObject {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "letters")
    
    var planeType = G.GameObjectType.PROP
    var flightLevel = G.FlightLevel.STABLE
    
    var currentAltitudeCommand: AltitudeCommand?
    var currentAltitude = 7000
    var desiredAltitude = 7000
    // the amount to change altitude on update (varies by plane type)
    let altDelta: Int
    
    var currentTurnCommand: TurnCommand?
    var currentHeading = Direction.N
    var desiredHeading = Direction.N
    
    var destination = G.Destination.Airport
    var destinationId = 1
    
    var flying = false
    var updated = true
    var ignore = false
    
    init(type planeType: G.GameObjectType, identifier: Character, flying: Bool, x: Int, y: Int) {
        self.planeType = planeType
        self.flying = flying
        
        if planeType == G.GameObjectType.JET {
            self.altDelta = 20
        } else {
            self.altDelta = 10
        }
        
        // TODO fix this to be variable and based on ident
        let planeTexture = textureAtlas.textureNamed("A")
        
        super.init(identifier: identifier, locX: x, locY: y, sprite: SKSpriteNode(texture: planeTexture))
        
        sprite?.zPosition = 100
        
        print("plane \(ident) starting at: \(locationX),\(locationY)")
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        if let sprite = self.sprite {
            scene.addChild(sprite)
        }
    }
    
    func command(_ cmd: Command) {
        if let alt = cmd as? AltitudeCommand {
            currentAltitudeCommand = alt
        } else if let _ = cmd as? MarkCommand {
            ignore = false
        } else if let _ = cmd as? IgnoreCommand {
            ignore = true
        } else if let _ = cmd as? UnmarkCommand {
            
            // TODO more to impl when we do Delayed commands
            ignore = true
        } else if let trn = cmd as? TurnCommand {
            currentTurnCommand = trn
        }
    }
    
    func handleCommand() {
        if let alt = currentAltitudeCommand {
            handleAltitudeCommand(alt)
        }
        
        if let trn = currentTurnCommand {
            handleTurnCommand(trn)
        }
    }
    
    func handleTurnCommand(_ trn: TurnCommand) {
        if trn.towards {
            
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
        if ignore {
            cmd = "------"
        } else {
            cmd = ""
        }
        
        return "\(ident)  \(currentAltitude)  \(dest) \(cmd)"
    }
    
    var ticks = 0
    
    // on 10 ticks we move the jet, on 20 ticks we move the plane, we update altitude every tick
    func tick() {
        ticks += 1
        if ticks == 21 {
            ticks = 0
        }
        
        handleCommand()
        
        updateAltitude()
        
        if ticks == 10 || ticks == 20 {
            if planeType == G.GameObjectType.JET {
                movePlane()
                updateDirection()
            } else if ticks == 20 && planeType == G.GameObjectType.PROP {
                movePlane()
                updateDirection()
            }
            
            // TODO
            // check location of plane to see if it lands or moves off
            // or crashes. Check for 0 altitude also. Check also for
            // collision with another plane
        }
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
        
        updated = true
        print("plane \(ident) altitude changed to: \(currentAltitude)")
    }
    
    func updateDirection() {
        if flying {
            if desiredHeading != currentHeading {
                let numAddsClock = currentHeading.distance(to: desiredHeading)
                let numAddsCounter = currentHeading.distance(to: desiredHeading)
                var numAdds = 0
                if(numAddsClock > numAddsCounter) {
                 //   numAdds
                }
                
                if numAdds > 2 {
                    numAdds = 2
                }
                
               currentHeading = currentHeading.add(times: numAdds)
            }
        }
    }
    
    func movePlane() {
        if flying {
            switch currentHeading {
            case Direction.N:
                locationY += 1
            case Direction.S:
                locationY -= 1
            case Direction.E:
                locationX += 1
            case Direction.W:
                locationX -= 1
            case Direction.NE:
                locationY += 1
                locationX += 1
            case Direction.NW:
                locationY += 1
                locationX -= 1
            case Direction.SE:
                locationY -= 1
                locationX += 1
            case Direction.SW:
                locationY -= 1
                locationX -= 1
            }
            
            updated = true
            print("plane \(ident) moved to: \(locationX),\(locationY)")
        }
    }
}
