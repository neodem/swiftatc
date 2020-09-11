//
//  PlaneDisplayModule.swift
//  atc
//
//  Created by Vincent Fumo on 9/11/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class PlaneDisplayModule : DisplayModule {
    var nextRow = 1
    
    override init(ident: Character, x: Int, y: Int, rows: Int, cols: Int) {
        super.init(ident: ident, x: x, y: y, rows: rows, cols: cols)
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        self.write(string: "PL ALT   DT   COMM", row: 0)
    }
    
    func addPlane(plane: Plane) {
        var dest: String
        if plane.destination == G.Destination.Airport {
            dest = "A\(plane.destinationId)"
        } else if plane.destination == G.Destination.Exit {
            dest = "E\(plane.destinationId)"
        } else if plane.destination == G.Destination.Beacon {
            dest = "B\(plane.destinationId)"
        } else {
            dest = ""
        }
        
        self.write(string: "\(plane.ident)  \(plane.altitude)  \(dest)", row: nextRow)
        
        nextRow += 1
    }
}
