//
//  Dum.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

struct G {
    
    enum GameObjectType : CaseIterable {
        case PROP, JET, AIRPORT, BEACON, AIRWAY, DISPLAY
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
    
    struct Radar {
        static let xMin: Float = 75
        static let xMax: Float = 715
        static let yMin: Float = 248
        static let yMax: Float = 888
    }
    
}
