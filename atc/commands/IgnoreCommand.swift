//
//  IgnoreCommand.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

class IgnoreCommand : Command {
    let ident: Character
    let commandText = "ignore"
    
    var complete = false
    
    init(ident: Character) {
        self.ident = ident
    }
    
    public func inputCharacter(_ char: Character) -> Bool {
        return false
    }
    
    public func getErrorMessage() -> String? {
        return nil
    }
    
}
