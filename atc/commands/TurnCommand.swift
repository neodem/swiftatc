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
    
    // turn towards
    var towards = false
    var destination: G.Destination?
    var destIdent: Character?
    
    init(ident: Character) {
        self.ident = ident
    }
    
    public func inputCharacter(_ key: Key) -> CommandInputResult {
        
        if towards {
            switch key {
            case Key.Delete:
                if destIdent != nil {
                    destIdent = nil
                } else if destination != nil {
                    destination = nil
                } else {
                    towards = false
                }
            case Key.E:
                if destination != nil {
                    return CommandInputResult.Illegal
                }
                destination = G.Destination.Exit
            case Key.A:
                if destination != nil {
                    return CommandInputResult.Illegal
                }
                destination = G.Destination.Airport
            case Key.B:
                if destination != nil {
                    return CommandInputResult.Illegal
                }
                destination = G.Destination.Beacon
            default:
                if key.isNumber() {
                    let intValue = key.numberAsInt()
                    let enumString = "\(intValue)"
                    destIdent = Character(enumString)
                    complete = true
                    return CommandInputResult.OK
                }
                
                return CommandInputResult.Illegal
            }
            
            return CommandInputResult.OK
        } else {
            // check for number or c or d
            switch key {
            case Key.Delete:
                if direction != nil {
                    direction = nil
                    complete = false
                }
                else if left || right {
                    left = false
                    right = false
                } else {
                    return CommandInputResult.Delete
                }
            case Key.E:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.NE
                complete = true
            case Key.W:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.N
                complete = true
            case Key.Q:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.NW
                complete = true
            case Key.D:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.E
                complete = true
            case Key.A:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.W
                complete = true
            case Key.Z:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.SW
                complete = true
            case Key.X:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.S
                complete = true
            case Key.C:
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                direction = G.Direction.SE
                complete = true
            case Key.T:
                towards = true
            case Key.L:
                if left == true || right == true {
                    return CommandInputResult.Illegal
                }
                
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                left = true
                right = false
            case Key.R:
                if left == true || right == true {
                    return CommandInputResult.Illegal
                }
                if direction != nil {
                    return CommandInputResult.Illegal
                }
                left = false
                right = true
            default:
                return CommandInputResult.Illegal
            }
            
            return CommandInputResult.OK
        }
    }
    
    public func getErrorMessage() -> String? {
        return nil
    }
    
    public func getCommandString() -> String? {
        var commandString = "turn "
        
        if towards {
            commandString += "towards "
            
            if let dest = destination {
                switch dest {
                case G.Destination.Airport:
                    commandString += "aiport: "
                case G.Destination.Exit:
                    commandString += "exit: "
                case G.Destination.Beacon:
                    commandString += "beacon: "
                }
            }
            
            if let destIdent = self.destIdent {
                commandString += "\(destIdent)"
            }
            
        } else {
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
        }
        
        return commandString
    }
    
}
