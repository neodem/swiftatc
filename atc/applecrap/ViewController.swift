//
//  ViewController.swift
//  atc
//
//  Created by Vincent Fumo on 9/8/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
//    lazy var window: NSWindow = self.view.window!
  //  var mouseLocation: NSPoint { NSEvent.mouseLocation }
//    var location: NSPoint { window.mouseLocationOutsideOfEventStream }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
//       //     print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
//            print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
//            return $0
//        }

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

