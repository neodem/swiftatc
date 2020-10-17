//
//  PlaneDisplayModule.swift
//  atc
//
//  Created by Vincent Fumo on 9/11/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class PlaneDisplayModule: DisplayModule {
    var nextRow = 1

    // plane ident : row
    var planes = [Character: Int]()

    override init(ident: Character, x: Int, y: Int, rows: Int, cols: Int) {
        super.init(ident: ident, x: x, y: y, rows: rows, cols: cols)
    }

    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        self.write(string: "PL ALT   DT   COMM", row: 0)
    }

    func addPlane(plane: Plane) {
        planes[plane.ident] = nextRow
        self.write(string: plane.getStatusLine(), row: nextRow)
        nextRow += 1
    }

    func removePlane(ident: Character) {
        if let row = planes[ident] {
            self.clear(row: row)
        }

        planes[ident] = nil

        // TODO shift things up and reset `nextRow`
    }

    func updatePlane(plane: Plane) {
        if let row = planes[plane.ident] {
            self.write(string: plane.getStatusLine(), row: row)
        }
    }
}
