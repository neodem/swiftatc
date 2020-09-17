//
//  TurnCommand.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

class TurnCommand : Command {
    let ident: Character
    
    var direction: G.Direction?
    
    var complete = false
    
    // the default case where we expect an absolute direction to be entered
    var immediate = true
    
    // relative turns
    var left = false
    var right = false
    
    init(ident: Character) {
        self.ident = ident
    }
    
    public func inputCharacter(_ key: Key) -> CommandInputResult {
        // check for number or c or d
        switch key {
        case Key.Delete:
            if direction != nil {
                direction = nil
            }
            else if left || right {
                left = false
                right = false
            }
        case Key.E:
            direction = G.Direction.NE
            complete = true
        case Key.W:
            direction = G.Direction.N
            complete = true
        case Key.Q:
            direction = G.Direction.NW
            complete = true
        case Key.D:
            direction = G.Direction.E
            complete = true
        case Key.A:
            direction = G.Direction.W
            complete = true
        case Key.Z:
            direction = G.Direction.SW
            complete = true
        case Key.X:
            direction = G.Direction.S
            complete = true
        case Key.C:
            direction = G.Direction.SE
            complete = true
            
        case Key.L:
            if left == true || right == true {
                return CommandInputResult.Illegal
            }
            left = true
            right = false
            
        case Key.R:
            if left == true || right == true {
                return CommandInputResult.Illegal
            }
            left = false
            right = true
        default:
            return CommandInputResult.Illegal
        }
        
         return CommandInputResult.OK
    }
    
    public func getErrorMessage() -> String? {
        return nil
    }
    
    public func getCommandString() -> String? {
        var commandString = "turn "
        
        if left {
            commandString += "left "
        } else if right {
            commandString += "right "
        } else if direction != nil {
            commandString += "to "
        }
        
        if direction != nil {
            commandString += "\(direction!.rawValue)"
        }
        
        return commandString
    }
    
}
