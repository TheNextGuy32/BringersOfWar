//
//  Constants.swift
//  BringersOfWar
//
//  Created by student on 9/25/17.
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

struct Sprites {
    static let BULLET       = #imageLiteral(resourceName: "Bullet.png")
    static let TOWER        = #imageLiteral(resourceName: "Tower.png")
    static let MARS_SURFACE = #imageLiteral(resourceName: "Mars CH16.png")
    static let NATIVE       = #imageLiteral(resourceName: "player.png")
}

struct NativesData {
    static let HEALTH           = 1
    static let MOVEMENT_SPEED:CGFloat   = 100.0
}

let FIXED_DELTA_TIME = CGFloat(0.01666666666)
