//
//  Dum.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

enum PhysicsCategory: UInt32 {
    case plane = 1
    case border = 2
    case airport = 4
    case exit = 8
    case beacon = 16
}

enum GameName {
    case EASY, MEDIUM, HARD, KILLER, TEST
}

struct G {

    enum GameObjectType: CaseIterable {
        case PROP, JET, AIRPORT, BEACON, AIRWAY, DISPLAY, PLANE
    }

    enum FlightLevel {
        case UP, DOWN, STABLE
    }

    enum Destination {
        case Airport, Exit, Beacon
    }

    enum GameState {
        case active, preActive, crashed, incorrectlyExited
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
        static let xMin: CGFloat = 70
        static let xMax: CGFloat = 910
        static let yMin: CGFloat = 290
        static let yMax: CGFloat = 1130
    }

    struct ZPos {
        static let exit: CGFloat = 5
        static let airport: CGFloat = 7
        static let plane: CGFloat = 20
        static let overlay: CGFloat = 100
        static let debug: CGFloat = 1000
    }

}
