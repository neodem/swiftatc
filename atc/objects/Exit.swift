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
    
    // todo these may change based on gridScale
    let gateOffset: Float = 25
    let exitBoundOffset: Float = 5
    let labelOffset: Float = 30
    
    let gateAlpha: CGFloat = 1.0
    let lineAlpha: CGFloat = 0.2
    let labelAlpha: CGFloat = 0.4
    
    let boundingBox : Box
    
    // outbound direction of the exit is `direction`
    init(ident: Character, x: Int, y: Int, direction: Direction, gridScale: Int) {
        
        let (xOrigin, yOrigin) = Grid.convertToRadarCoords(gridX: x,gridY: y, gridScale: gridScale)
        
        // the origins of the Left/Right Gates
        let leftGateX: Float
        let leftGateY: Float
        let rightGateX: Float
        let rightGateY: Float
        
        // the rotation of the gates
        let gateRotation: CGFloat
        
        // the cutoff factor of the gate lines (relevant in the Diagnal exits)
        var gateCutoff: Float = 1.0
                
        // label location
        var labelXloc: Float
        var labelYloc: Float
        
        switch direction {
        case Direction.N:
            gateRotation = 0
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset
            boundingBox = Box(x1: xOrigin - gateOffset, y1: yOrigin, x2: xOrigin + gateOffset, y2: yOrigin-gateOffset)
        case Direction.NE:
            gateRotation = 7 * .pi / 4
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin
            rightGateY = yOrigin - gateOffset
            labelXloc = xOrigin - labelOffset
            labelYloc = yOrigin - labelOffset
            gateCutoff = 2/3
            boundingBox = Box(x1: xOrigin - gateOffset, y1: yOrigin, x2: xOrigin + gateOffset, y2: yOrigin-gateOffset, x3: rightGateX, y3: leftGateY-gateOffset, x4: rightGateX, y4: leftGateY)
        case Direction.E:
            gateRotation = .pi * 3 / 2
            leftGateX = xOrigin
            leftGateY = yOrigin + gateOffset
            rightGateX = xOrigin
            rightGateY = yOrigin - gateOffset
            labelXloc = xOrigin - labelOffset
            labelYloc = yOrigin
            boundingBox = Box(x1: xOrigin - gateOffset, y1: yOrigin + gateOffset, x2: xOrigin, y2: yOrigin - gateOffset)
        case Direction.SE:
            gateRotation = 5 * .pi / 4
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin
            rightGateY = yOrigin + gateOffset
            labelXloc = xOrigin - labelOffset
            labelYloc = yOrigin + labelOffset
            gateCutoff = 2/3
            boundingBox = Box(x1: leftGateX, y1: leftGateY, x2: leftGateX, y2: leftGateY-gateOffset, x3: rightGateX, y3: leftGateY-gateOffset, x4: rightGateX, y4: leftGateY)
        case Direction.S:
            gateRotation = .pi
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin
            labelYloc = yOrigin + labelOffset
            boundingBox = Box(x1: xOrigin - gateOffset, y1: yOrigin + gateOffset, x2: xOrigin + gateOffset, y2: yOrigin)
        case Direction.SW:
            gateRotation = 3 * .pi / 4
            leftGateX = xOrigin
            leftGateY = yOrigin + gateOffset
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin + labelOffset
            labelYloc = yOrigin + labelOffset
            gateCutoff = 2/3
            boundingBox = Box(x1: leftGateX, y1: leftGateY, x2: leftGateX, y2: leftGateY-gateOffset, x3: rightGateX, y3: leftGateY-gateOffset, x4: rightGateX, y4: leftGateY)
        case Direction.W:
            gateRotation = .pi / 2
            leftGateX = xOrigin
            leftGateY = yOrigin + gateOffset
            rightGateX = xOrigin
            rightGateY = yOrigin - gateOffset
            labelXloc = xOrigin + labelOffset
            labelYloc = yOrigin
            boundingBox = Box(x1: xOrigin, y1: yOrigin + gateOffset, x2: xOrigin + gateOffset, y2: yOrigin - gateOffset)
        case Direction.NW:
            gateRotation = .pi / 4
            leftGateX = xOrigin
            leftGateY = yOrigin - gateOffset
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin + labelOffset
            labelYloc = yOrigin - labelOffset
            gateCutoff = 2/3
            boundingBox = Box(x1: leftGateX, y1: leftGateY, x2: leftGateX, y2: leftGateY-gateOffset, x3: rightGateX, y3: leftGateY-gateOffset, x4: rightGateX, y4: leftGateY)
        }
        
        leftGate = Gate(len: gateOffset, cutoff: gateCutoff, alpha: gateAlpha, rotation: gateRotation, x: CGFloat(leftGateX), y: CGFloat(leftGateY)).gateSprite
        rightGate = Gate(len: gateOffset, cutoff: gateCutoff, alpha: gateAlpha, rotation: gateRotation, x: CGFloat(rightGateX), y: CGFloat(rightGateY)).gateSprite
        
        gateLine = SKSpriteNode(color: NSColor.systemGreen, size: CGSize(width: 1, height: 100))
        gateLine.colorBlendFactor = 1.0
        gateLine.alpha = lineAlpha
        gateLine.zRotation = gateRotation
        gateLine.zPosition = G.ZPos.exit
        gateLine.anchorPoint = CGPoint(x: 0.5, y: 1)
        gateLine.position = CGPoint(x: CGFloat(xOrigin), y: CGFloat(yOrigin))
        
        exitLabel = SKLabelNode(fontNamed: "Andale Mono")
        exitLabel.text = "\(ident)"
        exitLabel.fontColor = NSColor.systemGreen
        exitLabel.alpha = labelAlpha
        exitLabel.fontSize = 34
        exitLabel.zRotation = gateRotation
        exitLabel.zPosition = G.ZPos.exit
        exitLabel.position = CGPoint(x: CGFloat(labelXloc), y: CGFloat(labelYloc))
        
        super.init(identifier: ident, locX: x, locY: y)
    }
    
    override func initialize(scene: SKScene) {
        super.initialize(scene: scene)
        scene.addChild(gateLine)
        scene.addChild(leftGate)
        scene.addChild(rightGate)
        scene.addChild(exitLabel)
    }
    
    func inExit(x: Int, y: Int) -> Bool {
      //  print("checking exit bounds : \(ident) \(x),\(y) against \(exitBoundXMin) \(exitBoundXMax) \(exitBoundYMin) \(exitBoundYMax)")
        // todo compute bounding box with angles
     //   return x >= exitBoundXMin && x <= exitBoundXMax && y >= exitBoundYMin && y <= exitBoundYMax
        return false
    }
}
