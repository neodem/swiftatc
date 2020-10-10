//
//  Box.swift
//  atc
//
//  Created by Vincent Fumo on 9/27/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

// a bounding box

import SpriteKit

class BoundingBox : BaseSceneAware {
    
    let boxSprite: SKSpriteNode
    
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    
    // init with the four points for non-rectangular
    init(topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        
        boxSprite = SKSpriteNode()
        let path = CGMutablePath()
        path.addLines(between: [
            self.topLeft,
            self.topRight,
            self.bottomRight,
            self.bottomLeft,
            self.topLeft
        ])
        path.closeSubpath()
        boxSprite.physicsBody = SKPhysicsBody(polygonFrom: path)
        boxSprite.physicsBody!.affectedByGravity = false
        boxSprite.physicsBody!.allowsRotation = false
        boxSprite.physicsBody!.isDynamic = false
        boxSprite.physicsBody!.contactTestBitMask = PhysicsCategory.plane.rawValue
        boxSprite.physicsBody!.categoryBitMask = PhysicsCategory.exit.rawValue
    }
    
    // init with 2 points for rectangle
    convenience init(topLeft: CGPoint, bottomRight: CGPoint) {
        self.init(topLeft: topLeft, topRight: CGPoint(x: bottomRight.x, y: topLeft.y), bottomLeft: CGPoint(x: topLeft.x, y: bottomRight.y), bottomRight: bottomRight)
    }
    
    override func initializeScene(scene: SKScene) {
        super.initializeScene(scene: scene)
        scene.addChild(boxSprite)
    }
    
    func isInside(x: Float, y: Float) -> Bool {
        return true
    }
}
