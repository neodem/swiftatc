//
//  Dum.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

struct G {
    static let kColor_Seperator = "s"
    
    enum GameObjectType : CaseIterable {
        case PROP, JET, AIRPORT, BEACON, AIRWAY
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
    
    enum GameState {
        case active, preActive
    }
    
}
