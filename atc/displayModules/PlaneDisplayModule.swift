//
//  PlaneDisplayModule.swift
//  atc
//
//  Created by Vincent Fumo on 9/11/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class PlaneDisplayModule: DisplayModule {
    let NOPLANE = Character("*")
    let NOSTATUS = ""

    var bottomRow = 1

    // [displayrow] == plane ident
    var displayRows = [Character]()

    // [displayrow] ==  status line
    var statusLines = [String]()

    override init(ident: Character, x: Int, y: Int, rows: Int, cols: Int) {
        super.init(ident: ident, x: x, y: y, rows: rows, cols: cols)

        // fill with NOPLANE and NOSTATUS
        displayRows = Array(repeating: NOPLANE, count: rows)
        statusLines = Array(repeating: NOSTATUS, count: rows)
    }

    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        self.write(string: "PL ALT   DT   COMM", row: 0)
    }

    func addPlane(plane: Plane) {
        let statusLine = plane.getStatusLine()

        // store data
        statusLines[bottomRow] = statusLine
        displayRows[bottomRow] = plane.ident

        // draw
        self.write(string: statusLine, row: bottomRow)

        // advance bottomRow
        bottomRow += 1
    }

    func removePlane(ident: Character) {
        if let row = getRowForPlane(ident: ident) {

            removePlaneFromRow(row: row)

            // shift things up
            shiftUp(deletedRow: row)

            bottomRow -= 1
        }
    }

    private func removePlaneFromRow(row: Int) { // un draw
        self.clear(row: row)

        // remove data
        displayRows[row] = NOPLANE
        statusLines[row] = NOSTATUS
    }

    private func getRowForPlane(ident: Character) -> Int? {
        for (index, element) in displayRows.enumerated() {
            if element == ident {
                return index
            }
        }

        return nil
    }

    private func shiftUp(deletedRow: Int) {
        let nextRow = deletedRow + 1
        if nextRow < bottomRow {
            if displayRows[nextRow] != NOPLANE {
                // shift up
                statusLines[deletedRow] = statusLines[nextRow]
                displayRows[deletedRow] = displayRows[nextRow]

                // draw
                self.write(string: statusLines[deletedRow], row: deletedRow)

                // remove old
                removePlaneFromRow(row: nextRow)
            }

            shiftUp(deletedRow: nextRow)
        }
    }

    func updatePlane(plane: Plane) {
        if let row = getRowForPlane(ident: plane.ident) {
            let statusLine = plane.getStatusLine()
            // store new status
            statusLines[row] = statusLine
            // draw
            self.write(string: statusLine, row: row)
        }
    }
}
