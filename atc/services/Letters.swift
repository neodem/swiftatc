//
//  Letters.swift
//  atc
//
//  Created by Vincent Fumo on 9/9/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import SpriteKit

class Lettters {

    static let space: UInt8 = 32
    static let bang: UInt8 = 33
    static let oparen: UInt8 = 40
    static let cparen: UInt8 = 41
    static let dash: UInt8 = 45
    static let period: UInt8 = 46
    static let zero: UInt8 = 48
    static let colon: UInt8 = 58
    static let uca: UInt8 = 65
    static let ucz: UInt8 = 90
    static let lca: UInt8 = 97
    static let lcz: UInt8 = 122

    // used in error casses where we cna't draw the character
    static let bash: UInt8 = 126

    static let up: UInt8 = 123
    static let down: UInt8 = 125

    static let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "letters")

    static func getLetterString(string: String, x: Int, y: Int) -> [SKSpriteNode] {
        var spriteString = [SKSpriteNode]()

        guard !string.isEmpty else {
            return spriteString
        }

        var xPos = x

        for letter in string {

            var texture: SKTexture

            if !isValid(character: letter) {
                texture = getTextureForLetter(letter: "~")
            } else {
                texture = getTextureForLetter(letter: letter)
            }

            let sprite = SKSpriteNode(texture: texture, size: CGSize(width: 20, height: 34))
            sprite.zPosition = 100
            sprite.anchorPoint = .zero
            sprite.position = CGPoint(x: xPos, y: y)

            spriteString.append(sprite)

            xPos += 20
        }

        return spriteString
    }

    static func isNumber(_ letter: Character) -> Bool {
        let ascii = letter.asciiValue!

        if ascii <= 57 || ascii >= 48 {
            return true
        }
        return false
    }

//    static func uppercase(_ letter: Character) -> Character {
//        // todo
//        return letter;
//    }

    static func getTextureForLetter(letter: Character) -> SKTexture {
        var ascii = letter.asciiValue!

        if ascii == space {
            return textureAtlas.textureNamed("space")
        } else if ascii == bash {
            return textureAtlas.textureNamed("bash")
        } else if ascii == bang {
            return textureAtlas.textureNamed("bang")
        } else if ascii == oparen {
            return textureAtlas.textureNamed("oparen")
        } else if ascii == cparen {
            return textureAtlas.textureNamed("cparen")
        } else if ascii == dash {
            return textureAtlas.textureNamed("dash")
        } else if ascii == period {
            return textureAtlas.textureNamed("period")
        } else if ascii == up {
            return textureAtlas.textureNamed("up")
        } else if ascii == down {
            return textureAtlas.textureNamed("down")
        } else if ascii == colon {
            return textureAtlas.textureNamed("colon")
        }

        // for now we only have UC letter textures so we convert lc to uc
        if ascii >= lca && ascii <= lcz {
            ascii = ascii - 32
        }

        let unit8 = UInt8(ascii)
        let scalar = UnicodeScalar(unit8)
        let textureName = String(scalar)

        return textureAtlas.textureNamed(textureName)

    }

//    static func getLetterAsString(ascii: Int) -> String? {
//        guard ascii < 0 && ascii > 26 else {
//            return nil
//        }
//
//        return String(UnicodeScalar(UInt8(ascii)))
//    }
//
//    // for a given string, return a Texture composed of the string values
//    // only letters and numbers are allowed
//    static func getTextureForString(string: String) -> SKTexture? {
//        //
//        //        let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "letters")
//        //        var composition: [SKTexture]
//        //
//        //        for letter in string {
//        //
//        //        }
//        //
//        //        string.forEach({
//        //            var texture: SKTexture = textureAtlas.textureNamed(String($0))
//        //            composition.append(texture)
//        //        })
//
//        return textureAtlas.textureNamed("A")
//    }


    // valid values are
    // 32 - space
    // 33 - !
    // 40 - (
    // 41 - )
    // 45 - -
    // 46 - .
    // 48-57 : numbers 0-9
    // 58 - :
    // 65-90 : uc letters A-Z
    // 97-122 : lc letters a-z
    // 123 : up
    // 125 : down
    static func isValid(character: Character) -> Bool {
        guard character.isASCII else {
            return false
        }

        let ascii = character.asciiValue!

        if ascii < space || ascii > 122 {
            return false
        }

        if ascii >= space && ascii <= bang {
            return true
        }

        if ascii >= oparen && ascii <= cparen {
            return true
        }

        if ascii >= dash && ascii <= period {
            return true
        }

        if ascii >= zero && ascii <= colon {
            return true
        }

        if ascii >= uca && ascii <= ucz {
            return true
        }

        if ascii >= lca && ascii <= lcz {
            return true
        }

        if ascii == up {
            return true
        }

        if ascii == down {
            return true
        }

        return false

    }
}
