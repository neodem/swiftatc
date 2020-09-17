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
    
    enum Direction : String {
        case N = "0"
        case NE = "45"
        case E = "90"
        case SE = "135"
        case S = "180"
        case SW = "225"
        case W = "270"
        case NW = "315"
    }
    
    enum Destination {
        case Airport, Exit, Beacon
    }
    
    enum GameState {
        case active, preActive
    }
    
    struct PlaneDisplay {
        static let x: Int = 1030
        static let y: Int = 1130
    }
    
    struct ScoreDisplay {
        static let x: Int = 1030
        static let y: Int = 600
    }
    
    struct CommandDisplay {
        static let x: Int = 69
        static let y: Int = 170
    }
    
    struct LetterSize {
        static let width = 20
        static let height = 34
    }
    
    struct Radar {
        static let xMin: Float = 90
        static let xMax: Float = 898
        static let yMin: Float = 320
        static let yMax: Float = 1112
    }
    
}
