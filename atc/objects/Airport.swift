//
// Created by Vincent Fumo on 10/18/20.
// Copyright (c) 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Airport: BaseSceneAware {

    let airportSprite: SKSpriteNode
    let runwayLine: SKSpriteNode
    let airportLabel: SKLabelNode

    let boundingBox: BoundingBox

    let labelOffset: CGFloat = 30

    let airportAlpha: CGFloat = 1.0
    let lineAlpha: CGFloat = 0.2
    let labelAlpha: CGFloat = 0.4

    let ident: Character
    let boardX: Int
    let boardY: Int
    let direction: Direction

    // runway direction is the direction.. eg. N would mean planes needed to land facing N
    init(ident: Character, boardX: Int, boardY: Int, direction: Direction, gridScale: Int) {
        self.ident = ident
        self.boardX = boardX
        self.boardY = boardY
        self.direction = direction

        // the location of the airport (in graphics x,y)
        let (xOrigin, yOrigin) = Grid.convertToRadarCoords(gridX: boardX, gridY: boardY, gridScale: gridScale)

        // the rotation of the gates
        let gateRotation: CGFloat

        // label location
        var labelXloc: CGFloat
        var labelYloc: CGFloat

        switch direction {
        case Direction.N:
            gateRotation = 0
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.NE:
            gateRotation = 7 * .pi / 4
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.E:
            gateRotation = .pi * 3 / 2
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.SE:
            gateRotation = 5 * .pi / 4
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.S:
            gateRotation = .pi
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.SW:
            gateRotation = 3 * .pi / 4
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.W:
            gateRotation = .pi / 2
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset

        case Direction.NW:
            gateRotation = .pi / 4
            labelXloc = xOrigin
            labelYloc = yOrigin - labelOffset
        }

        boundingBox = BoundingBox(
                topLeft: CGPoint(x: xOrigin - 15, y: yOrigin + 15),
                bottomRight: CGPoint(x: xOrigin + 15, y: yOrigin - 15)
        )

        airportSprite = SKSpriteNode(color: NSColor.systemGreen, size: CGSize(width: 25, height: 25))
        airportSprite.colorBlendFactor = 1.0
        airportSprite.alpha = lineAlpha
        airportSprite.zRotation = gateRotation
        airportSprite.zPosition = G.ZPos.airport
        airportSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        airportSprite.position = CGPoint(x: xOrigin, y: yOrigin)

        runwayLine = SKSpriteNode(color: NSColor.systemGreen, size: CGSize(width: 1, height: 100))
        runwayLine.colorBlendFactor = 1.0
        runwayLine.alpha = lineAlpha
        runwayLine.zRotation = gateRotation
        runwayLine.zPosition = G.ZPos.airport
        runwayLine.anchorPoint = CGPoint(x: 0.5, y: 1)
        runwayLine.position = CGPoint(x: xOrigin, y: yOrigin + 20)

        airportLabel = SKLabelNode(fontNamed: "Andale Mono")
        airportLabel.text = "\(ident)"
        airportLabel.fontColor = NSColor.systemGreen
        airportLabel.alpha = labelAlpha
        airportLabel.fontSize = 34
        airportLabel.zRotation = gateRotation
        airportLabel.zPosition = G.ZPos.airport
        airportLabel.position = CGPoint(x: labelXloc, y: labelYloc)

    }

    override func initializeScene(scene: SKScene) {
        super.initializeScene(scene: scene)
        scene.addChild(airportSprite)
        scene.addChild(runwayLine)
        scene.addChild(airportLabel)
    }

    func inAirport(sprite: SKNode) -> Bool {
        boundingBox.isInside(point: sprite.position)
    }
}
