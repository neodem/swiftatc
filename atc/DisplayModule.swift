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
    
    var sprites = [Int: [SKSpriteNode]]()
    
    // x,y represent the top left of the module
    init(ident: Character, x: Int, y: Int, rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        super.init(identifier: ident, locX: x, locY: y, sprite: nil)
    }
    
    // clear an entire row
    func clear(row: Int) {
        guard row >= 0 && row < rows else {
            return
        }
        
        if let spriteRow = sprites[row] {
            for sprite in spriteRow {
                sprite.removeFromParent()
            }
            
            sprites.removeValue(forKey: row)
        }
    }
//
//    // clear one character -- maybe not impl?
//    func clear(row: Int, col: Int) {
//        guard row >= 0 && row < rows else {
//            return
//        }
//        guard col >= 0 && col < cols else {
//            return
//        }
//    }
    
//    // write a string to a row starting at col 0 but don't clear first
//    func overWrite(string: String, row: Int) {
//        self.overWrite(string: string, row: row, col: 0)
//    }
//
//    // write a string to a row starting at a specific col but don't clear first
//    func overWrite(string: String, row: Int, col: Int) {
//        guard row >= 0 && row < rows else {
//            return
//        }
//        guard col >= 0 && col < cols else {
//            return
//        }
//    }
    
    // write a string to a row starting at col 0 and clear entire row first
    func write(string: String, row: Int) {
        self.write(string: string, row: row, col: 0)
    }
    
    // write a string to a row starting at a specific col and clear entire row first
    func write(string: String, row: Int, col: Int) {
        guard row >= 0 && row < rows else {
            return
        }
        
        clear(row: row)
        
        let xPos = self.locationX - 20 - (row * 20)
        let yPos = self.locationY + 5 + (col * 10)
        
        let spriteRow = Lettters.getLetterString(string: string, x: xPos, y: yPos)
        
        sprites[row] = spriteRow
    }
    
    func getSprites() -> [SKSpriteNode] {
        var allSprites = [SKSpriteNode]()
        
        for (_, spriteRow) in sprites {
            allSprites.append(contentsOf: spriteRow)
        }
        
        return allSprites
    }
    
}
