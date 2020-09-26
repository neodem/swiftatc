//
//  Exit.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Exit : BaseGameObject {
    
    let gateLine: SKSpriteNode
    let leftGate: SKSpriteNode
    let rightGate: SKSpriteNode
    let exitLabel: SKLabelNode
    
    let gateOffset: Float = 50
    
    let leftXloc: Float
    let leftYloc: Float
    
    let rightXloc: Float
    let rightYloc: Float
    
    let gateRotation: CGFloat
    
    // outbound direction of the exit is `direction`
    init(ident: Character, x: Int, y: Int, direction: Direction, gridScale: Int) {
        
        let xOrigin: Float
        let yOrigin: Float
        (xOrigin, yOrigin) = Grid.convertToRadarCoords(gridX: x,gridY: y, gridScale: gridScale)
        
        let gateLen: Double = 30
        var gateCutoff = 1.0
        
        let gateAlpha: CGFloat = 1.0
        let lineAlpha: CGFloat = 0.2
        let labelAlpha: CGFloat = 0.5
        
        var labelXloc: Float
        var labelYloc: Float
        
        switch direction {
        case Direction.N:
            gateRotation = 0
            leftXloc = xOrigin - gateOffset
            leftYloc = yOrigin
            rightXloc = xOrigin + gateOffset
            rightYloc = yOrigin
            labelXloc = xOrigin - 60
            labelYloc = yOrigin - 15
        case Direction.NE:
            gateRotation = 7 * .pi / 4
            leftXloc = xOrigin - gateOffset
            leftYloc = yOrigin
            rightXloc = xOrigin
            rightYloc = yOrigin - gateOffset
            labelXloc = xOrigin - 75
            labelYloc = yOrigin - 15
            gateCutoff = 2/3
        case Direction.E:
            gateRotation = .pi * 3 / 2
            leftXloc = xOrigin
            leftYloc = yOrigin + gateOffset
            rightXloc = xOrigin
            rightYloc = yOrigin - gateOffset
            labelXloc = xOrigin - 15
            labelYloc = yOrigin + 60
        case Direction.SE:
            gateRotation = 5 * .pi / 4
            leftXloc = xOrigin - gateOffset
            leftYloc = yOrigin
            rightXloc = xOrigin
            rightYloc = yOrigin + gateOffset
            labelXloc = xOrigin - 15
            labelYloc = yOrigin + 75
            gateCutoff = 2/3
        case Direction.S:
            gateRotation = .pi
            leftXloc = xOrigin - gateOffset
            leftYloc = yOrigin
            rightXloc = xOrigin + gateOffset
            rightYloc = yOrigin
            labelXloc = xOrigin - 60
            labelYloc = yOrigin + 5
        case Direction.SW:
            gateRotation = 3 * .pi / 4
            leftXloc = xOrigin
            leftYloc = yOrigin + Float(gateOffset)
            rightXloc = xOrigin + Float(gateOffset)
            rightYloc = yOrigin
            labelXloc = xOrigin + 15
            labelYloc = yOrigin + 75
            gateCutoff = 2/3
        case Direction.W:
            gateRotation = .pi / 2
            leftXloc = xOrigin
            leftYloc = yOrigin + Float(gateOffset)
            rightXloc = xOrigin
            rightYloc = yOrigin - Float(gateOffset)
            labelXloc = xOrigin + 15
            labelYloc = yOrigin + 60
        case Direction.NW:
            gateRotation = .pi / 4
            leftXloc = xOrigin
            leftYloc = yOrigin - Float(gateOffset)
            rightXloc = xOrigin + Float(gateOffset)
            rightYloc = yOrigin
            labelXloc = xOrigin + 75
            labelYloc = yOrigin - 15
            gateCutoff = 2/3
        }
        
        // this dot is for debug purpouses to show the "axis" of the exit
        //        dot = SKSpriteNode(color: NSColor.systemRed, size: CGSize(width: 1, height: 1))
        //        dot.colorBlendFactor = 1.0
        //        dot.alpha = 1.0
        //        dot.zPosition = 200
        //        dot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //        dot.position = CGPoint(x: CGFloat(xOrigin), y: CGFloat(yOrigin))
        
        leftGate = Gate(len: gateLen, cutoff: gateCutoff, alpha: gateAlpha, rotation: gateRotation, x: CGFloat(leftXloc), y: CGFloat(leftYloc)).gateSprite
        rightGate = Gate(len: gateLen, cutoff: gateCutoff, alpha: gateAlpha, rotation: gateRotation, x: CGFloat(rightXloc), y: CGFloat(rightYloc)).gateSprite
        
        gateLine = SKSpriteNode(color: NSColor.systemGreen, size: CGSize(width: 1, height: 100))
        gateLine.colorBlendFactor = 1.0
        gateLine.alpha = lineAlpha
        gateLine.zRotation = gateRotation
        gateLine.zPosition = G.ZPos.exit
        gateLine.anchorPoint = CGPoint(x: 0.5, y: 1)
        gateLine.position = CGPoint(x: CGFloat(xOrigin), y: CGFloat(yOrigin))
        
        exitLabel = SKLabelNode(fontNamed: "Andale Mono")
        exitLabel.text = "\(ident)"
        exitLabel.fontColor = NSColor.white
        exitLabel.alpha = labelAlpha
        exitLabel.fontSize = 14
        exitLabel.zPosition = G.ZPos.exit
        exitLabel.position = CGPoint(x: CGFloat(labelXloc), y: CGFloat(labelYloc))
        
        super.init(identifier: ident, locX: Int(xOrigin), locY: Int(yOrigin))
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        scene.addChild(gateLine)
        scene.addChild(leftGate)
        scene.addChild(rightGate)
        scene.addChild(exitLabel)
        //  scene.addChild(dot)
    }
}
