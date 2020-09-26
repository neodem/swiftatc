//
//  Dum.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

struct G {
    
    enum GameObjectType : CaseIterable {
        case PROP, JET, AIRPORT, BEACON, AIRWAY, DISPLAY
    }
    
    enum FlightLevel {
        case UP, DOWN, STABLE
    }
    
    enum Destination {
        case Airport, Exit, Beacon
    }
    
    enum GameState {
        case active, preActive, crashed
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
        static let xMin: Float = 70
        static let xMax: Float = 910
        static let yMin: Float = 290
        static let yMax: Float = 1130
    }
    
    struct ZPos {
        static let exit: CGFloat = 5
        static let plane: CGFloat = 10
        static let overlay: CGFloat = 100
        static let debug: CGFloat = 1000
    }
    
}
