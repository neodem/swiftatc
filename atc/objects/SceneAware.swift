//
//  SceneAware.swift
//  atc
//
//  Created by Vincent Fumo on 10/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//


import SpriteKit

protocol SceneAware {
    func initializeScene(scene: SKScene)
}

class BaseSceneAware : SceneAware {

    var scene: SKScene?
    
    func initializeScene(scene: SKScene) {
        self.scene = scene
    }
}
