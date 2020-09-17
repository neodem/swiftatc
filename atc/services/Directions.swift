//
//  Directions.swift
//  atc
//
//  Created by Vincent Fumo on 9/17/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

enum Direction : Int {
    case N = 0
    case NE = 45
    case E = 90
    case SE = 135
    case S = 180
    case SW = 225
    case W = 270
    case NW = 315
}

extension Direction {
    
    // return the number of 45 degree turns clockwise to get to the other one
    func distance(to: Direction) -> Int {
        var from = self.rawValue
        let to = to.rawValue
        
        var distance = 0
        while from != to {
            distance += 1
            from += 45
            if from == 360 {
                from = 0
            }
        }
    
        return distance
    }
    
    // return the number of 45 degree turns counterclockwise to get to the other one
    func distanceCounter(to: Direction) -> Int {
        var from = self.rawValue
        let to = to.rawValue
        
        var distance = 0
        while from != to {
            distance += 1
            from -= 45
            if from == -45 {
                from = 315
            }
        }
    
        return distance
    }
    
    // will add 45 degrees (eg. clockwise)
    func add() -> Direction {
        return add(times: 1)
    }
    
    func add(times: Int) -> Direction {
        var next = self.rawValue + (45 * times)
        
        if next >= 360 {
            let mult = next / 360
            next = next - (360 * mult)
        }
      
        return Direction(rawValue: next)!
    }
    
    // will subtract 45 degrees (eg. counterclockwise)
    func sub() -> Direction {
        return sub(times: 1)
    }
    
    func sub(times: Int) -> Direction {
   
        
        var next = self.rawValue - (45 * times)
        
        if next < 0 {
            let mult = abs(next) / 360
            next = next + (360 * mult)
        }
      
        return Direction(rawValue: next)!
    }
}
