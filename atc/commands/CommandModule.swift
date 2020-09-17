//
//  CommandModule.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//
class CommandModule : DisplayModule {
    
    var planeIdent: Character?
    var command: Command?
    
    override init(ident: Character, x: Int, y: Int, rows: Int, cols: Int) {
        super.init(ident: ident, x: x, y: y, rows: rows, cols: cols)
    }
    
    func reset() {
        // clear command line on screen
        self.clear(row: 0)
        self.clear(row: 1)
        
        // reset state
        planeIdent = nil
        command = nil
    }
    
    public func inputKey(_ key: Key) -> Command? {
        
        // print("command key: \(key)")
        
        if key == Key.Escape {
            reset()
        } else if key == Key.Delete {
            if planeIdent == nil {
                // do nothing
            } else if command == nil {
                reset()
            } else {
               let result = command!.inputCharacter(key)
                switch result {
                case CommandInputResult.Illegal:
                    beep()
                case CommandInputResult.Delete:
                    command = nil
                    self.clearToEnd(row: 0, col: 3)
                default:
                    if let commandString = command!.getCommandString() {
                        // print command on screen
                        self.overWriteToEnd(string: commandString, row: 0, col: 3)
                    } else {
                        beep()
                    }
                }

            }
        } else if key == Key.Return {
            if handleEnter() {
                let cmd = command
                reset()
                return cmd
            }
        } else if planeIdent == nil {
            createItent(key)
        } else if command == nil {
            createCommand(key)
        } else {
            let result = command!.inputCharacter(key)
            
            switch result {
            case CommandInputResult.Illegal:
                beep()
            default:
                if let commandString = command!.getCommandString() {
                    // print command on screen
                    self.overWriteToEnd(string: commandString, row: 0, col: 3)
                } else {
                    beep()
                }
            }
            
        }
        
        return nil
    }

    
    // on keyboard error we should beep
    func beep() {
        
    }
    
    func createCommand(_ key: Key) {
        if key == Key.A {
            command = AltitudeCommand(ident: planeIdent!)
        } else if key == Key.M {
            command = MarkCommand(ident: planeIdent!)
        } else if key == Key.I {
            command = IgnoreCommand(ident: planeIdent!)
        } else if key == Key.U {
            command = UnmarkCommand(ident: planeIdent!)
        } else if key == Key.C {
            command = CircleCommand(ident: planeIdent!)
        } else if key == Key.T {
            command = TurnCommand(ident: planeIdent!)
        }
        
        if let commandString = command?.getCommandString() {
            // print command on screen
            self.overWrite(string: commandString, row: 0, col: 3)
        } else {
            beep()
        }
        
    }
    
    func createItent(_ key: Key) {
        // check to see if we have a valid letter from a-z
        // if not, we beep
        
        let enumString = "\(key)"
        
        planeIdent = Character(enumString)
        
        drawIdent()
    }
    
    func drawIdent() {
        // draw on screen (ex: "a: ")
        self.write(string: "\(planeIdent!):", row: 0)
    }
    
    func handleEnter() -> Bool {
        if let _ = command?.complete {
            // check for errors
            if let errorMessage = command!.getErrorMessage() {
                // print error message on next line down
                self.write(string: errorMessage, row: 1)
            } else {
                return true
            }
        } else {
            // beep
        }
        
        return false
    }
}
