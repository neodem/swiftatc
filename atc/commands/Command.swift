//
//  Command.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

protocol Command {
    var ident: Character { get }
    var commandText: String { get }
    var complete: Bool { get }
    
    // return true if accepted
    func inputCharacter(_ char: Character) -> Bool
    
    // return nil if no errors
    func getErrorMessage() -> String?
    
    func getCommandString() -> String?
}
