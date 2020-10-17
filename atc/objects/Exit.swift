//
//  Exit.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Exit: BaseSceneAware {

    let gateLine: SKSpriteNode
    let leftGate: SKSpriteNode
    let rightGate: SKSpriteNode
    let exitLabel: SKLabelNode

    // todo these may change based on gridScale
    let gateOffset: CGFloat = 25
    let exitBoundOffset: CGFloat = 5
    let labelOffset: CGFloat = 30

    let gateAlpha: CGFloat = 1.0
    let lineAlpha: CGFloat = 0.2
    let labelAlpha: CGFloat = 0.4

    let boundingBox: BoundingBox

    let ident: Character

    // outbound direction of the exit is `direction`
    init(ident: Character, boardX: Int, boardY: Int, direction: Direction, gridScale: Int) {

        self.ident = ident

        let (xOrigin, yOrigin) = Grid.convertToRadarCoords(gridX: boardX, gridY: boardY, gridScale: gridScale)

        // the origins of the Left/Right Gates
        let leftGateX: CGFloat
        let leftGateY: CGFloat
        let rightGateX: CGFloat
        let rightGateY: CGFloat

        // the rotation of the gates
        let gateRotation: CGFloat

        // the cutoff factor of the gate lines (relevant in the Diagnal exits)
        var gateCutoff: CGFloat = 1.0

        // label location
        var labelXloc: CGFloat
        var labelYloc: CGFloat

        switch direction {
        case Direction.N:
            gateRotation = 0
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset
            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )
        case Direction.NE:
            gateRotation = 7 * .pi / 4
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin
            rightGateY = yOrigin - gateOffset
            labelXloc = xOrigin - labelOffset
            labelYloc = yOrigin - labelOffset
            gateCutoff = 2 / 3

            //TODO fix this
            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )
        case Direction.E:
            gateRotation = .pi * 3 / 2
            leftGateX = xOrigin
            leftGateY = yOrigin + gateOffset
            rightGateX = xOrigin
            rightGateY = yOrigin - gateOffset
            labelXloc = xOrigin - labelOffset
            labelYloc = yOrigin

            //TODO fix this

            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )
        case Direction.SE:
            gateRotation = 5 * .pi / 4
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin
            rightGateY = yOrigin + gateOffset
            labelXloc = xOrigin - labelOffset
            labelYloc = yOrigin + labelOffset
            gateCutoff = 2 / 3

            //TODO fix this
            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )
        case Direction.S:
            gateRotation = .pi
            leftGateX = xOrigin - gateOffset
            leftGateY = yOrigin
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin
            labelYloc = yOrigin + labelOffset

            //TODO fix this

            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )

        case Direction.SW:
            gateRotation = 3 * .pi / 4
            leftGateX = xOrigin
            leftGateY = yOrigin + gateOffset
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin + labelOffset
            labelYloc = yOrigin + labelOffset
            gateCutoff = 2 / 3

            //TODO fix this
            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )
        case Direction.W:
            gateRotation = .pi / 2
            leftGateX = xOrigin
            leftGateY = yOrigin + gateOffset
            rightGateX = xOrigin
            rightGateY = yOrigin - gateOffset
            labelXloc = xOrigin + labelOffset
            labelYloc = yOrigin

            //TODO fix this

            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )

        case Direction.NW:
            gateRotation = .pi / 4
            leftGateX = xOrigin
            leftGateY = yOrigin - gateOffset
            rightGateX = xOrigin + gateOffset
            rightGateY = yOrigin
            labelXloc = xOrigin + labelOffset
            labelYloc = yOrigin - labelOffset
            gateCutoff = 2 / 3

            //TODO fix this

            boundingBox = BoundingBox(
                    topLeft: CGPoint(x: xOrigin - gateOffset, y: yOrigin),
                    bottomRight: CGPoint(x: xOrigin + gateOffset, y: yOrigin - gateOffset)
            )
        }

        leftGate = Gate(len: gateOffset, cutoff: gateCutoff, alpha: gateAlpha, rotation: gateRotation, x: leftGateX, y: leftGateY).gateSprite
        rightGate = Gate(len: gateOffset, cutoff: gateCutoff, alpha: gateAlpha, rotation: gateRotation, x: rightGateX, y: rightGateY).gateSprite

        gateLine = SKSpriteNode(color: NSColor.systemGreen, size: CGSize(width: 1, height: 100))
        gateLine.colorBlendFactor = 1.0
        gateLine.alpha = lineAlpha
        gateLine.zRotation = gateRotation
        gateLine.zPosition = G.ZPos.exit
        gateLine.anchorPoint = CGPoint(x: 0.5, y: 1)
        gateLine.position = CGPoint(x: xOrigin, y: yOrigin)

        exitLabel = SKLabelNode(fontNamed: "Andale Mono")
        exitLabel.text = "\(ident)"
        exitLabel.fontColor = NSColor.systemGreen
        exitLabel.alpha = labelAlpha
        exitLabel.fontSize = 34
        exitLabel.zRotation = gateRotation
        exitLabel.zPosition = G.ZPos.exit
        exitLabel.position = CGPoint(x: labelXloc, y: labelYloc)
    }

    override func initializeScene(scene: SKScene) {
        super.initializeScene(scene: scene)
        scene.addChild(gateLine)
        scene.addChild(leftGate)
        scene.addChild(rightGate)
        scene.addChild(exitLabel)
    }

    func inExit(sprite: SKNode) -> Bool {
        return boundingBox.isInside(point: sprite.position)
    }
}
