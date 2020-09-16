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
    var heading = G.Direction.N
    var altitude = 7000
    let altDelta: Int
    
    var destination = G.Destination.Airport
    var destinationId = 1
    var flying = false
    var updated = true
    
    var currentAltitudeCommand: AltitudeCommand?
    
    init(type planeType: G.GameObjectType, identifier: Character, flying: Bool, x: Int, y: Int) {
        self.planeType = planeType
        self.flying = flying
        
        if planeType == G.GameObjectType.JET {
            self.altDelta = 20
        } else {
            self.altDelta = 10
        }
        
        // all flying planes default to 7k
        var altString = "0"
        if flying {
            altString = "7"
        }
        
        let identString = String(identifier) + altString
        
        let planeTexture = Lettters.getTextureForString(string: identString)
        
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
        }
    }
    
    func handleCommand() {
        if let alt = currentAltitudeCommand {
            
            let desiredAltitude = alt.desiredAltitude!
            
            if desiredAltitude > altitude {
                flightLevel = G.FlightLevel.UP
            } else if desiredAltitude < altitude {
                flightLevel = G.FlightLevel.DOWN
            } else if desiredAltitude == altitude {
                flightLevel = G.FlightLevel.STABLE
            }
        }
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
        
        return "\(ident)  \(altitude)  \(dest)"
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
            } else if ticks == 20 && planeType == G.GameObjectType.PROP {
                movePlane()
            }
            
            // TODO
            // check location of plane to see if it lands or moves off
            // or crashes. Check for 0 altitude also. Check also for
            // collision with another plane
        }
        
    }
    
    func updateAltitude() {
        guard flightLevel != G.FlightLevel.STABLE else {
            return
        }
        if flying {
            if flightLevel == G.FlightLevel.UP {
                altitude += altDelta
            } else {
                altitude -= altDelta
            }
            
            updated = true
            print("plane \(ident) altitude changed to: \(altitude)")
        }
    }
    
    func movePlane() {
        if flying {
            switch heading {
            case G.Direction.N:
                locationY += 1
            case G.Direction.S:
                locationY -= 1
            case G.Direction.E:
                locationX += 1
            case G.Direction.W:
                locationX -= 1
            case G.Direction.NE:
                locationY += 1
                locationX += 1
            case G.Direction.NW:
                locationY += 1
                locationX -= 1
            case G.Direction.SE:
                locationY -= 1
                locationX += 1
            case G.Direction.SW:
                locationY -= 1
                locationX -= 1
            }
            
            updated = true
            print("plane \(ident) moved to: \(locationX),\(locationY)")
        }
    }
}
