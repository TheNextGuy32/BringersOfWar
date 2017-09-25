//
//  PhysicsInfo.swift
//  BringersOfWar
//
//  Created by student on 9/24/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory {
    static let NONE     : UInt32 = 0b0
    static let ALL      : UInt32 = UInt32.max
    
    static let BULLET   : UInt32 = 0b1
    static let NATIVE   : UInt32 = 0b10
}
