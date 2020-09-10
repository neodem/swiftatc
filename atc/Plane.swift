//
//  Plane.swift
//  atc
//
//  Created by Vincent Fumo on 9/9/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

enum PlaneType {
    case PROP, JET
}

enum FlightLevel {
    case UP, DOWN, STABLE
}

enum Direction {
    case N, NE, E, SE, S, SW, W, NW
}

enum Destination {
    case Airport, Exit
}

class Plane: SKSpriteNode {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "letters")
    
    var planeType = PlaneType.PROP
    var flightLevel = FlightLevel.STABLE
    var heading = Direction.N
    var altitude = 7000
    var ident = 0
    var clock = 0
    var planeLocationX = 0
    var planeLocationY = 0
    var destination = Destination.Airport
    var destinationId = 1
    var flying = false
    
    // 0-26 for identifier
    init(type planeType: PlaneType, identifier: Int) {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        guard identifier >= 0 && identifier <= 26 else {
            return
        }
        
        self.ident = identifier
        
        //        let planeTexture
        
        
        
        self.planeType = planeType
    }
    
    func update() {
        clock += 1
        if clock == 21 {
            clock = 0
        }
        
        updateAltitude()
        
        if clock == 10 || clock == 20 {
            if planeType == PlaneType.JET {
                movePlane()
            } else if clock == 20 && planeType == PlaneType.PROP{
                movePlane()
            }
            
            // TODO
            // check location of plane to see if it lands or moves off
            // or crashes. Check for 0 altitude also. Check also for
            // collision with another plane
        }
        
    }
    
    func updateAltitude() {
        guard flightLevel == FlightLevel.STABLE else {
            return
        }
        if flying {
            if flightLevel == FlightLevel.UP {
                altitude += 100
            } else {
                altitude -= 100
            }
        }
    }
    
    func movePlane() {
        if flying {
            switch heading {
            case Direction.N:
                planeLocationY += 1
            case Direction.S:
                planeLocationY -= 1
            case Direction.E:
                planeLocationX += 1
            case Direction.W:
                planeLocationX -= 1
            case Direction.NE:
                planeLocationY += 1
                planeLocationX += 1
            case Direction.NW:
                planeLocationY += 1
                planeLocationX -= 1
            case Direction.SE:
                planeLocationY -= 1
                planeLocationX += 1
            case Direction.SW:
                planeLocationY -= 1
                planeLocationX -= 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
