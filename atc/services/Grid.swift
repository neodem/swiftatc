//
//  grid.swift
//  atc
//
//  Created by Vincent Fumo on 9/22/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Grid {
    
    static func convertToRadarCoords(gridX: Int, gridY: Int, gridScale: Int) -> (radarX: CGFloat, radarY: CGFloat) {
        // translate x,y into the xVal and yVal for radar screen
        let xOrigin = ((G.Radar.xMax - G.Radar.xMin) * (CGFloat(gridX) / CGFloat(gridScale))) + G.Radar.xMin
        let yOrigin = ((G.Radar.yMax - G.Radar.yMin) * (CGFloat(gridY) / CGFloat(gridScale))) + G.Radar.yMin
        
        return (radarX: xOrigin, radarY: yOrigin)
    }
    
    // transform a given x,y coord to a new origin (return floats)
    static func transform(originX: Int, originY: Int, x: Int, y: Int) -> (Float, Float) {
        
        let xVal = originX + x
        let yVal = originY + y
        
        return (Float(xVal), Float(yVal))
    }
    
    // for a given scalar on an axis, determine it's value in the given scale
    // eg. scalar = 10, scaleFrom = 100, scaleTo = 123, result = 12.3
    static func adapt(scaleFrom: Int, scaleTo: Int, scalar: Int) -> Float {
        let percentage: Float = Float(scalar) / Float(scaleFrom)
        return percentage * Float(scaleTo)
    }

}
