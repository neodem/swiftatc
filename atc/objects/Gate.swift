//
//  Gate.swift
//  atc
//
//  Created by Vincent Fumo on 9/24/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Gate {
    
    let gateSprite: SKSpriteNode
    
    init(len: CGFloat, cutoff: CGFloat, alpha: CGFloat, rotation: CGFloat, x: CGFloat, y: CGFloat) {
        let gateLength = len * cutoff
        gateSprite = SKSpriteNode(color: NSColor.systemGreen, size: CGSize(width: 1, height: Double(gateLength)))
        gateSprite.colorBlendFactor = 1.0
        gateSprite.alpha = alpha
        gateSprite.zRotation = rotation
        gateSprite.zPosition = G.ZPos.debug
        gateSprite.anchorPoint = CGPoint(x: 1, y: 1)
        gateSprite.position = CGPoint(x: x, y: y)
    }
}
