//
//  UnmarkCommand.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

class UnmarkCommand: Command {
    let ident: Character
    var complete = true

    init(ident: Character) {
        self.ident = ident
    }

    public func inputCharacter(_ key: Key) -> CommandInputResult {
        return CommandInputResult.Illegal
    }

    public func getErrorMessage() -> String? {
        return nil
    }

    public func getCommandString() -> String? {
        let commandString = "unmark"

        return commandString
    }

}
