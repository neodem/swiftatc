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
 
    var destination = G.Destination.Airport
    var destinationId = 1
    var flying = false
    var moved = false
    
    init(type planeType: G.GameObjectType, identifier: Character, flying: Bool, x: Int, y: Int) {
        self.planeType = planeType
        self.flying = flying
        
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
        moved = true
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        if let sprite = self.sprite {
            scene.addChild(sprite)
        }
    }
    
    var ticks = 0
    
    // on 10 ticks we move the jet, on 20 ticks we move the plane, we update altitude every tick
    func tick() {
        ticks += 1
        if ticks == 21 {
            ticks = 0
        }
        
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
                altitude += 100
            } else {
                altitude -= 100
            }
            
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
            
            moved = true
            print("plane \(ident) moved to: \(locationX),\(locationY)")
        }
    }
}
