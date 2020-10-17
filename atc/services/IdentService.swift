//
//  IdentService.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

protocol IdentService {
    func getIdent(type: G.GameObjectType) -> Character
    func returnIdent(type: G.GameObjectType, ident: Character)
}

class DefaultIdentService: IdentService {

    var nextIdent = [G.GameObjectType: Character]()


    // TODO fix this so that the idents for jets/planes are sequential
    // and just vary in case.. eg: A, b, c, D, etc


    init() {
        nextIdent[G.GameObjectType.AIRPORT] = "0"
        nextIdent[G.GameObjectType.BEACON] = "0"
        nextIdent[G.GameObjectType.AIRWAY] = "0"
        nextIdent[G.GameObjectType.JET] = "a"
        nextIdent[G.GameObjectType.PROP] = "A"
        nextIdent[G.GameObjectType.DISPLAY] = "A"
    }

    func getIdent(type: G.GameObjectType) -> Character {
        let next = nextIdent[type]!

        var nextAscii = next.asciiValue! + 1

        if type == G.GameObjectType.AIRPORT || type == G.GameObjectType.BEACON || type == G.GameObjectType.AIRWAY {
            if nextAscii == 58 {
                nextAscii = 48
            }
        } else if type == G.GameObjectType.JET {
            if nextAscii == 123 {
                nextAscii = 97
            }
        } else if type == G.GameObjectType.PROP {
            if nextAscii == 91 {
                nextAscii = 65
            }
        }

        nextIdent[type] = Character.init(UnicodeScalar(nextAscii))

        return next
    }

    func returnIdent(type: G.GameObjectType, ident: Character) {
        // not implemtned yet.. for now we simply overflow/loop
    }
}
