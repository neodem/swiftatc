//
//  Command.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

protocol Command {
    var ident: Character { get }
    var complete: Bool { get }
    
    // return true if accepted
    func inputCharacter(_ key: Key) -> CommandInputResult
    
    // return nil if no errors
    func getErrorMessage() -> String?
    
    // make a string of the command
    func getCommandString() -> String?
}

enum CommandInputResult {
    case OK
    
    // key not regognized/allowed
    case Illegal
    
    // the delete should bubble up (eg. cancel command)
    case Delete
}
