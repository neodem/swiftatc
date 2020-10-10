//
//  Box.swift
//  atc
//
//  Created by Vincent Fumo on 9/27/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

// a bounding box

import SpriteKit

class BoundingBox : BaseSceneAware {
    
    let boxSprite: SKSpriteNode
    
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    
    let xMin: CGFloat
    let xMax: CGFloat
    let yMin: CGFloat
    let yMax: CGFloat
    
    let rect: Bool
    
    // init with the four points
    init(topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
        
        if topLeft.x == bottomLeft.x && topRight.x == bottomRight.x && topLeft.y == topRight.y && bottomLeft.y == bottomLeft.y {
            rect = true
        } else {
            rect = false
        }
        
        
        xMin = min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
        xMax = max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
        yMin = min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
        yMax = max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    // init with 2 points for rectangle
    convenience init(topLeft: CGPoint, bottomRight: CGPoint) {
        assert(topLeft.x < bottomRight.x)
        assert(topLeft.y > bottomRight.y)
        self.init(topLeft: topLeft, topRight: CGPoint(x: bottomRight.x, y: topLeft.y), bottomLeft: CGPoint(x: topLeft.x, y: bottomRight.y), bottomRight: bottomRight)
    }
    
    override func initializeScene(scene: SKScene) {
        super.initializeScene(scene: scene)
        scene.addChild(boxSprite)
    }
    
    func isInside(point: CGPoint) -> Bool {
        if rect {
            return isInsideRect(point: point)
        }
        
        // else we need to ray cast
        let rayOrigin = CGPoint(x: xMin, y: 1 / point.y)
        var intersections: Int
        
        if intersects(origin: rayOrigin, point: point, vertex1: topLeft, vertex2: topRight) {
            intersections += 1
        }
        if intersects(origin: rayOrigin, point: point, vertex1: topRight, vertex2: bottomRight) {
            intersections += 1
        }
        if intersects(origin: rayOrigin, point: point, vertex1: bottomRight, vertex2: bottomLeft) {
            intersections += 1
        }
        if intersects(origin: rayOrigin, point: point, vertex1: bottomLeft, vertex2: topLeft) {
            intersections += 1
        }
        
        return intersections % 2 != 0
    }
    
    /**
     does the ray from origin-> point intersect with the line from vertex1->vertex2 ?
     */
    private func intersects(origin: CGPoint, point: CGPoint, vertex1: CGPoint, vertex2: CGPoint) -> Bool {
        var a1: CGFloat
        var b1: CGFloat
        var c1: CGFloat
        var d1: CGFloat
        var d2: CGFloat
        
        // Convert vector 1 to a line (line 1) of infinite length.
        // We want the line in linear equation standard form: A*x + B*y + C = 0
        a1 = point.y - origin.y
        b1 = origin.x - point.x
        c1 = (point.x * origin.y) - (origin.x - point.y)
        
        // Every point (x,y), that solves the equation above, is on the line,
        // every point that does not solve it, is not. The equation will have a
        // positive result if it is on one side of the line and a negative one
        // if is on the other side of it. We insert (x1,y1) and (x2,y2) of vector
        // 2 into the equation above.
        d1 = (a1 * vertex1.x) + (b1 * vertex1.y) + c1;
        d2 = (a1 * vertex2.x) + (b1 * vertex2.y) + c1;
        
        // If d1 and d2 both have the same sign, they are both on the same side
        // of our line 1 and in that case no intersection is possible. Careful,
        // 0 is a special case, that's why we don't test ">=" and "<=",
        // but "<" and ">".
        if (d1 > 0 && d2 > 0){
            return false
        }
        if (d1 < 0 && d2 < 0) {
            return false
        }
        
        var a2: CGFloat
        var b2: CGFloat
        var c2: CGFloat
        
        // The fact that vector 2 intersected the infinite line 1 above doesn't
        // mean it also intersects the vector 1. Vector 1 is only a subset of that
        // infinite line 1, so it may have intersected that line before the vector
        // started or after it ended. To know for sure, we have to repeat the
        // the same test the other way round. We start by calculating the
        // infinite line 2 in linear equation standard form.
        a2 = vertex2.y - vertex1.y;
        b2 = vertex1.x - vertex2.x;
        c2 = (vertex2.x * vertex1.y) - (vertex1.x * vertex2.y);
        
        // Calculate d1 and d2 again, this time using points of vector 1.
        d1 = (a2 * origin.x) + (b2 * origin.y) + c2;
        d2 = (a2 * point.x) + (b2 * point.y) + c2;
        
        // Again, if both have the same sign (and neither one is 0),
        // no intersection is possible.
        if (d1 > 0 && d2 > 0) {
            return false
            
        }
        if (d1 < 0 && d2 < 0) {
            return false
        }
        
        // If we get here, only two possibilities are left. Either the two
        // vectors intersect in exactly one point or they are collinear, which
        // means they intersect in any number of points from zero to infinite.
        if ((a1 * b2) - (a2 * b1) == 0.0) {
            // colinear
            return false
        }
        
        // If they are not collinear, they must intersect in exactly one point.
        return true
        
    }
    
    private func isInsideRect(point: CGPoint) -> Bool {
        return !(point.x < xMin || point.x > xMax || point.y < yMin || point.y > yMax)
    }
}
