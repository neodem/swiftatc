//
//  DisplayModule.swift
//  atc
//
//  Created by Vincent Fumo on 9/11/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class DisplayModule : BaseGameObject {
    
    let rows: Int
    let cols: Int
    
    // row/col/sprite
    var sprites: [[SKSpriteNode?]]
    
    // x,y represent the top left of the module
    init(ident: Character, x: Int, y: Int, rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        self.sprites = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        
        super.init(identifier: ident, locX: x, locY: y, sprite: nil)
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
    }
    
    // clear an entire row
    func clear(row: Int) {
        self.clear(row: row, colStart: 0, colEnd: cols)
    }
        
    // clear to end of row starting at col
    func clearToEnd(row: Int, col: Int) {
        clear(row: row, colStart: col, colEnd: cols)
    }
    
    // clear from some col to some other col
    func clear(row: Int, colStart: Int, colEnd: Int) {
        guard row >= 0 && row < rows else {
            return
        }
        
        for col in colStart..<colEnd {
            if let sprite = sprites[row][col] {
                sprite.removeFromParent()
                sprites[row][col] = nil
            }
        }
    }
    
    // will clear from col -> end and write string starting at col
    func overWriteToEnd(string: String, row: Int, col: Int) {
        guard row >= 0 && row < rows else {
            return
        }
        guard col >= 0 && col < cols else {
            return
        }
        guard string.count > 0 else {
            return
        }
        clear(row: row, colStart: col, colEnd: cols)
        makeSprites(col, row, string)
    }
    
    // write a string to a row starting at col 0 but don't clear first
    func overWrite(string: String, row: Int) {
        self.overWrite(string: string, row: row, col: 0)
    }
    
    // write a string to a row starting at a specific col but don't clear first
    func overWrite(string: String, row: Int, col: Int) {
        guard row >= 0 && row < rows else {
            return
        }
        guard col >= 0 && col < cols else {
            return
        }
        guard string.count > 0 else {
            return
        }
        
        clear(row: row, colStart: col, colEnd: col + string.count)
        makeSprites(col, row, string)
    }
    
    // write a string to a row starting at col 0 and clear entire row first
    func write(string: String, row: Int) {
        self.write(string: string, row: row, col: 0)
    }
    
    func write(string: String, row: Int, col: Int) {
        guard row >= 0 && row < rows else {
            return
        }
        
        clear(row: row)
        makeSprites(col, row, string)
    }
    
    // write a string to a stored row starting at a specific col and clear entire row first
    fileprivate func makeSprites(_ col: Int, _ row: Int, _ string: String) {
        let xPos = self.locationX + (col * G.LetterSize.width)
        let yPos = self.locationY - (row * G.LetterSize.height)
        
        let spriteRow = Lettters.getLetterString(string: string, x: xPos, y: yPos)
        
        for index in 0..<string.count {
            let sprite = spriteRow[index]
            let columIndex = index + col
            scene?.addChild(sprite)
            sprites[row][columIndex] = sprite
        }
    }
}
