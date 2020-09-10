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
    var sprite: SKSpriteNode? { get set }
}

class BaseGameObject : GameObject {
    var ident: Character
    var locationX: Int
    var locationY: Int
    var sprite: SKSpriteNode?
    
    init(identifier: Character, locX: Int, locY: Int, sprite: SKSpriteNode?) {
        self.ident = identifier
        self.locationX = locX
        self.locationY = locY
        self.sprite = sprite
    }
}
