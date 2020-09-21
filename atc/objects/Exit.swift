//
//  Exit.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Exit : BaseGameObject {
    
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "exit")
    
    let exitLabel: SKLabelNode
    let gateLine: SKSpriteNode
    let leftGate: SKSpriteNode
    let rightGate: SKSpriteNode
    
    init(ident: Character, x: Int, y: Int, direction: Direction) {
        
        let lineTexture = textureAtlas.textureNamed("line")
        let gateTexture = textureAtlas.textureNamed("gate")
        
        /// this is for the left gate.. the other gate will be flipped accordingly
        //        var rotation: Float
        //        var flip: Bool
        //        switch direction {
        //        case Direction.N:
        //            rotation = 0
        //            flip = false
        //        case Direction.NE:
        //            rotation = 0
        //            flip = false
        //        case Direction.E:
        //            rotation = 0
        //            flip = false
        //        case Direction.SE:
        //            rotation = 0
        //            flip = false
        //        case Direction.S:
        //            rotation = 0
        //            flip = false
        //        case Direction.SW:
        //            rotation = 0
        //            flip = true
        //        case Direction.W:
        //            rotation = 0
        //            flip = false
        //        case Direction.NW:
        //            rotation = 0
        //            flip = false
        //        }
        
        let xLoc = Float(x) / Float(140)
        let yLoc = Float(y) / Float(140)
        
        let xVal = ((G.Radar.xMax - G.Radar.xMin) * xLoc) + G.Radar.xMin
        let yVal = ((G.Radar.yMax - G.Radar.yMin) * yLoc) + G.Radar.yMin
        
        gateLine = SKSpriteNode(texture: lineTexture, color: NSColor.systemGreen, size: CGSize(width: 10, height: 30))
        gateLine.colorBlendFactor = 1.0
        gateLine.alpha = 0.5
        gateLine.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        gateLine.position = CGPoint(x: CGFloat(xVal), y: CGFloat(yVal))
        
        leftGate = SKSpriteNode(texture: gateTexture, color: NSColor.systemGreen, size: CGSize(width: 20, height: 20))
        leftGate.colorBlendFactor = 1.0
        leftGate.alpha = 0.8
        leftGate.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        leftGate.position = CGPoint(x: CGFloat(xVal-20), y: CGFloat(yVal))
        
        rightGate = SKSpriteNode(texture: gateTexture, color: NSColor.systemGreen, size: CGSize(width: 20, height: 20))
        rightGate.colorBlendFactor = 1.0
        rightGate.alpha = 0.8
        rightGate.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        rightGate.position = CGPoint(x: CGFloat(xVal+20), y: CGFloat(yVal))
        
        exitLabel = SKLabelNode(fontNamed: "Andale Mono 14.0")
        exitLabel.text = "\(ident)"
        exitLabel.fontColor = NSColor.white
        exitLabel.fontSize = 14
        exitLabel.position = CGPoint(x: CGFloat(xVal-30), y: CGFloat(yVal-30))
        
        super.init(identifier: ident, locX: x, locY: y, sprite: nil)
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
//        scene.addChild(gateLine)
//        scene.addChild(leftGate)
//        scene.addChild(rightGate)
        scene.addChild(exitLabel)
    }
}
