//
//  AltitudeCommand.swift
//  atc
//
//  Created by Vincent Fumo on 9/13/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import Foundation

class AltitudeCommand: Command {
    let ident: Character
    var complete = false
    var desiredAltitude: Int?
    var climb = false
    var descend = false

    init(ident: Character) {
        self.ident = ident
    }

    public func inputCharacter(_ key: Key) -> CommandInputResult {


        // check for number or c or d
        switch key {
        case Key.Delete:
            if desiredAltitude != nil {
                desiredAltitude = nil
            } else if climb == true {
                climb = false
            } else if descend == true {
                descend = false
            } else {
                return CommandInputResult.Delete
            }
        case Key.Zero:
            desiredAltitude = 0
            complete = true
        case Key.One:
            desiredAltitude = 1000
            complete = true
        case Key.Two:
            desiredAltitude = 2000
            complete = true
        case Key.Three:
            desiredAltitude = 3000
            complete = true
        case Key.Four:
            desiredAltitude = 4000
            complete = true
        case Key.Five:
            desiredAltitude = 5000
            complete = true
        case Key.Six:
            desiredAltitude = 6000
            complete = true
        case Key.Seven:
            desiredAltitude = 7000
            complete = true
        case Key.Eight:
            desiredAltitude = 8000
            complete = true
        case Key.Nine:
            desiredAltitude = 9000
            complete = true
        case Key.C:
            if climb == true || descend == true {
                return CommandInputResult.Illegal
            }
            climb = true
            descend = false
        case Key.D:
            if climb == true || descend == true {
                return CommandInputResult.Illegal
            }
            climb = false
            descend = true
        default:
            return CommandInputResult.Illegal
        }

        return CommandInputResult.OK
    }

    public func getErrorMessage() -> String? {
        return nil
    }

    public func getCommandString() -> String? {
        var commandString = "altitude:"

        if climb {
            commandString += " climb"
        } else if descend {
            commandString += " descend"
        }

        if let alt = desiredAltitude {
            commandString += " \(alt) feet"
        }

        return commandString
    }

}
