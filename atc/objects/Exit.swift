//
//  Exit.swift
//  atc
//
//  Created by Vincent Fumo on 9/10/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import Foundation

class Exit : BaseGameObject {
    init(ident: Character, x: Int, y: Int) {
        super.init(identifier: ident, locX: x, locY: y, sprite: nil)
    }
}
