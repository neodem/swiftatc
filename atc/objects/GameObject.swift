//
//  GameObject.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

protocol GameObject {
    var ident: Character { get set }
    var locationX: Int  { get set }
    var locationY: Int  { get set }
    func initialize(scene: SKScene)
}

class BaseGameObject : GameObject {
    var ident: Character
    var locationX: Int
    var locationY: Int
    var scene: SKScene?
    
    init(identifier: Character, locX: Int, locY: Int) {
        self.ident = identifier
        self.locationX = locX
        self.locationY = locY
    }
    
    func initialize(scene: SKScene) {
        self.scene = scene
    }
}
