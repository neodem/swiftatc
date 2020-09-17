//
//  IgnoreCommand.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

class IgnoreCommand : Command {
    let ident: Character
    var complete = true
    
    init(ident: Character) {
        self.ident = ident
    }
    
    public func inputCharacter(_ key: Key) -> Bool {
        return false
    }
    
    public func getErrorMessage() -> String? {
        return nil
    }
    
    public func getCommandString() -> String? {
        let commandString = "ignore"
        
        return commandString
    }
}
