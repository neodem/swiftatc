//
//  Plane.swift
//  atc
//
//  Created by Vincent Fumo on 9/9/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Plane: SKSpriteNode {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "letters")
    
    var planeType = G.GameObjectType.PROP
    var flightLevel = G.FlightLevel.STABLE
    var heading = G.Direction.N
    var altitude = 7000
    var ident: Character = "A"
    var clock = 0
    var planeLocationX = 0
    var planeLocationY = 0
    var destination = G.Destination.Airport
    var destinationId = 1
    var flying = false
    
    // 0-26 for identifier
    init(type planeType: G.GameObjectType, identifier: Character) {
        self.ident = identifier
        self.planeType = planeType
        
        let planeTexture: SKTexture = Letters.getTextureForString(identifier)
        
        super.init(texture: planeTexture, color: .clear, size: initialSize)
    }
    
    func update() {
        clock += 1
        if clock == 21 {
            clock = 0
        }
        
        updateAltitude()
        
        if clock == 10 || clock == 20 {
            if planeType == G.GameObjectType.JET {
                movePlane()
            } else if clock == 20 && planeType == G.GameObjectType.PROP {
                movePlane()
            }
            
            // TODO
            // check location of plane to see if it lands or moves off
            // or crashes. Check for 0 altitude also. Check also for
            // collision with another plane
        }
        
    }
    
    func updateAltitude() {
        guard flightLevel == G.FlightLevel.STABLE else {
            return
        }
        if flying {
            if flightLevel == G.FlightLevel.UP {
                altitude += 100
            } else {
                altitude -= 100
            }
        }
    }
    
    func movePlane() {
        if flying {
            switch heading {
            case G.Direction.N:
                planeLocationY += 1
            case G.Direction.S:
                planeLocationY -= 1
            case G.Direction.E:
                planeLocationX += 1
            case G.Direction.W:
                planeLocationX -= 1
            case G.Direction.NE:
                planeLocationY += 1
                planeLocationX += 1
            case G.Direction.NW:
                planeLocationY += 1
                planeLocationX -= 1
            case G.Direction.SE:
                planeLocationY -= 1
                planeLocationX += 1
            case G.Direction.SW:
                planeLocationY -= 1
                planeLocationX -= 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
