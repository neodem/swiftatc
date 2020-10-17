//
//  GameScene.swift
//  atc
//
//  Created by Vincent Fumo on 9/8/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    let gameManager = DefaultGameManager()
    var lastFrameTime = TimeInterval(0)

    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.physicsWorld.contactDelegate = self
        gameManager.initialize(scene: self)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        // the only thing that moves is a plane. Lets see what it collided with
        let otherBody: SKPhysicsBody
        if (contact.bodyA.categoryBitMask & PhysicsCategory.plane.rawValue) > 0 {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        switch otherBody.categoryBitMask {
        case PhysicsCategory.exit.rawValue:
            print("hit an exit")
        case PhysicsCategory.airport.rawValue:
            print("hit an airport")
        case PhysicsCategory.beacon.rawValue:
            print("hit an beacon")
        case PhysicsCategory.exit.rawValue:
            print("hit an exit")
        default:
            print("contact with no game logic")
        }
    }

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastFrameTime
        if delta > 0.1 {
            lastFrameTime = currentTime
            // approx every 0.1 second...
            gameManager.tick()
        }

        if let key = Keyboard.instance.keysPressed.dequeue() {
            gameManager.handleKey(key)
        }
    }

    override func didFinishUpdate() {
        Keyboard.instance.update()
    }

    override func keyUp(with event: NSEvent) {
        //        print("keyUp: \(event)")
        Keyboard.instance.handleKey(event: event, isDown: false)
    }

    override func keyDown(with event: NSEvent) {
        //        print("keyDown: \(event)")
        Keyboard.instance.handleKey(event: event, isDown: true)
    }
}
