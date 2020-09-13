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
    
    public func inputCharacter(_ character: Character) {
        
        if character == "x" {
            // TODO replace "x" with ESCAPE char
            reset()
        } else if character == "x" {
            // TODO replace "x" with BACKSPACE char
            if planeIdent == nil {
                // do nothing
            } else if command == nil {
                reset()
            } else {
                command = nil
                // clear all of the command line except the ident
            }
        } else if character == "x" {
            // TODO replace "x" with "return/enter"
            handleEnter()
        } else if planeIdent == nil {
            createItent(character)
        } else if command == nil {
            createCommand(character)
        } else {
            let accepted = command!.inputCharacter(character)
            
            if !accepted {
                // beep
            }
        }
    }
    
    func createCommand(_ character: Character) {
        if character == "a" {
            command = AltitudeCommand(ident: planeIdent!)
        } else if character == "m" {
            command = MarkCommand(ident: planeIdent!)
        } else if character == "i" {
            command = IgnoreCommand(ident: planeIdent!)
        } else if character == "u" {
            command = UnmarkCommand(ident: planeIdent!)
        } else if character == "c" {
            command = CircleCommand(ident: planeIdent!)
        } else if character == "t" {
            command = TurnCommand(ident: planeIdent!)
        }
        
        // print command on screen
        self.overWrite(string: command.getCommandString(), row: 0, col: 3)
    }
    
    func createItent(_ character: Character) {
        // check to see if we have a valid letter from a-z
        // if not, we beep
        
        planeIdent = character
        
        // draw on screen (ex: "a: ")
        let string = "\(character):"
        
        self.write(string: string, row: 0)
    }
    
    func processCommand() {
        // check for errors
        if let errorMessage = command!.getErrorMessage() {
            // print error message on next line down
            return
        }
        
        // dispatch command
        
        reset()
    }
    
    func handleEnter() {
        if let _ = command?.complete {
            processCommand()
        } else {
            // beep
        }
    }
}
