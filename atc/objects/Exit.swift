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
    let gateOffset: Int = 25
    let exitBoundOffset: Float = 5
    
    let leftXloc: Float
    let leftYloc: Float
    
    let rightXloc: Float
    let rightYloc: Float
    
    let gateRotation: CGFloat
    
    let exitBoundXMin: Float
    let exitBoundXMax: Float
    let exitBoundYMin: Float
    let exitBoundYMax: Float
    
    // outbound direction of the exit is `direction`
    init(ident: Character, x: Int, y: Int, direction: Direction, gridScale: Int) {
        
        let (xOrigin, yOrigin) = Grid.convertToRadarCoords(gridX: x,gridY: y, gridScale: gridScale)
        
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
            leftXloc = xOrigin - Float(gateOffset)
            leftYloc = yOrigin
            rightXloc = xOrigin + Float(gateOffset)
            rightYloc = yOrigin
            labelXloc = xOrigin - 60
            labelYloc = yOrigin - 15
            exitBoundXMin = Float(x) - exitBoundOffset
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y)
        case Direction.NE:
            gateRotation = 7 * .pi / 4
            leftXloc = xOrigin - Float(gateOffset)
            leftYloc = yOrigin
            rightXloc = xOrigin
            rightYloc = yOrigin - Float(gateOffset)
            labelXloc = xOrigin - 75
            labelYloc = yOrigin - 15
            gateCutoff = 2/3
            exitBoundXMin = Float(x)
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y) + exitBoundOffset
        case Direction.E:
            gateRotation = .pi * 3 / 2
            leftXloc = xOrigin
            leftYloc = yOrigin + Float(gateOffset)
            rightXloc = xOrigin
            rightYloc = yOrigin - Float(gateOffset)
            labelXloc = xOrigin - 15
            labelYloc = yOrigin + 60
            exitBoundXMin = Float(x) - exitBoundOffset
            exitBoundXMax = Float(x)
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y) + exitBoundOffset
        case Direction.SE:
            gateRotation = 5 * .pi / 4
            leftXloc = xOrigin - Float(gateOffset)
            leftYloc = yOrigin
            rightXloc = xOrigin
            rightYloc = yOrigin + Float(gateOffset)
            labelXloc = xOrigin - 15
            labelYloc = yOrigin + 75
            gateCutoff = 2/3
            exitBoundXMin = Float(x)
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y) + exitBoundOffset
        case Direction.S:
            gateRotation = .pi
            leftXloc = xOrigin - Float(gateOffset)
            leftYloc = yOrigin
            rightXloc = xOrigin + Float(gateOffset)
            rightYloc = yOrigin
            labelXloc = xOrigin - 60
            labelYloc = yOrigin + 5
            exitBoundXMin = Float(x) - exitBoundOffset
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y)
            exitBoundYMax = Float(y) + exitBoundOffset
        case Direction.SW:
            gateRotation = 3 * .pi / 4
            leftXloc = xOrigin
            leftYloc = yOrigin + Float(gateOffset)
            rightXloc = xOrigin + Float(gateOffset)
            rightYloc = yOrigin
            labelXloc = xOrigin + 15
            labelYloc = yOrigin + 75
            gateCutoff = 2/3
            exitBoundXMin = Float(x)
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y) + exitBoundOffset
        case Direction.W:
            gateRotation = .pi / 2
            leftXloc = xOrigin
            leftYloc = yOrigin + Float(gateOffset)
            rightXloc = xOrigin
            rightYloc = yOrigin - Float(gateOffset)
            labelXloc = xOrigin + 15
            labelYloc = yOrigin + 60
            exitBoundXMin = Float(x)
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y) + exitBoundOffset
        case Direction.NW:
            gateRotation = .pi / 4
            leftXloc = xOrigin
            leftYloc = yOrigin - Float(gateOffset)
            rightXloc = xOrigin + Float(gateOffset)
            rightYloc = yOrigin
            labelXloc = xOrigin + 75
            labelYloc = yOrigin - 15
            gateCutoff = 2/3
            exitBoundXMin = Float(x)
            exitBoundXMax = Float(x) + exitBoundOffset
            exitBoundYMin = Float(y) - exitBoundOffset
            exitBoundYMax = Float(y) + exitBoundOffset
        }
        
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
