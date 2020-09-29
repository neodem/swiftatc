//
//  Box.swift
//  atc
//
//  Created by Vincent Fumo on 9/27/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

// a bounding box

class Box {
    
    // top left
    let x1: Float
    let y1: Float
    
    // bottom right
    let x2: Float
    let y2: Float
    
    // bottom left
    let x3: Float
    let y3: Float
    
    // bottom right
    let x4: Float
    let y4: Float
    
    let rect: Bool
    
    // init with 2 points for rectangle
    init(x1: Float, y1: Float, x2: Float, y2: Float) {
        rect = true
        if x1 < x2 {
            self.x1 = x1
            self.y1 = y1
            self.x2 = x2
            self.y2 = y2
            
            self.x3 = x1
            self.y3 = y2
            self.x4 = x2
            self.y4 = y1
        } else {
            self.x1 = x2
            self.y1 = y2
            self.x2 = x1
            self.y2 = y1
            
            self.x3 = x2
            self.y3 = y1
            self.x4 = x1
            self.y4 = y2
        }
        
    }
    
    // init with the four points for non-rectangular
    init(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float, x4: Float, y4: Float) {
        rect = false
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.x3 = x3
        self.y3 = y3
        self.x4 = x4
        self.y4 = y4
    }
    
    func isInside(x: Float, y: Float) -> Bool {
        return true
    }
}
