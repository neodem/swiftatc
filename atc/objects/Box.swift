//
//  Box.swift
//  atc
//
//  Created by Vincent Fumo on 9/27/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

// a bounding box

import SpriteKit

class Box {
    
    let boxSprite: SKSpriteNode
    
    // top left
    let x1: CGFloat
    let y1: CGFloat
    
    // bottom right
    let x2: CGFloat
    let y2: CGFloat
    
    // bottom left
    let x3: CGFloat
    let y3: CGFloat
    
    // bottom right
    let x4: CGFloat
    let y4: CGFloat
    
    let rect: Bool
    
    // init with 2 points for rectangle
    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        rect = true
        if x1 < x2 {
            self.x1 = x1
            self.y1 = y1
            self.x2 = x2
            self.y2 = y2
            
            self.x3 = x1
            self.y3 = y2
            self.x4 = x2
            self.y4 = y1
        } else {
            self.x1 = x2
            self.y1 = y2
            self.x2 = x1
            self.y2 = y1
            
            self.x3 = x2
            self.y3 = y1
            self.x4 = x1
            self.y4 = y2
        }
        
        boxSprite = SKSpriteNode()
        let path = CGMutablePath()
        path.addLines(between: [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x2, y: y2),
            CGPoint(x: x3, y: y3),
            CGPoint(x: x4, y: x4),
            CGPoint(x: x1, y: y1)
        ])
        path.closeSubpath()
        boxSprite.physicsBody = SKPhysicsBody(polygonFrom: path)
        boxSprite.physicsBody?.categoryBitMask = PhysicsCategory.exit.rawValue
        
    }
    
    // init with the four points for non-rectangular
    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, x3: CGFloat, y3: CGFloat, x4: CGFloat, y4: CGFloat) {
        rect = false
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.x3 = x3
        self.y3 = y3
        self.x4 = x4
        self.y4 = y4
        
        boxSprite = SKSpriteNode()
        let path = CGMutablePath()
        path.addLines(between: [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x2, y: y2),
            CGPoint(x: x3, y: y3),
            CGPoint(x: x4, y: x4),
            CGPoint(x: x1, y: y1)
        ])
        path.closeSubpath()
        boxSprite.physicsBody = SKPhysicsBody(polygonFrom: path)
        boxSprite.physicsBody?.categoryBitMask = PhysicsCategory.exit.rawValue
    }
    
    func isInside(x: Float, y: Float) -> Bool {
        return true
    }
}
