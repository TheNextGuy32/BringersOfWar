//
//  Constants.swift
//  BringersOfWar
//
//  Created by student on 9/25/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit

// Physics Categories for collision
struct PhysicsCategory {
    static let NONE     : UInt32 = 0b0
    static let ALL      : UInt32 = UInt32.max
    
    static let BULLET   : UInt32 = 0b1
    static let NATIVE   : UInt32 = 0b10
    static let BASE     : UInt32 = 0b100
    static let TOWER    : UInt32 = 0b1000
}

// Images used by game objects
struct Sprites {
    static let BULLET       = #imageLiteral(resourceName: "Bullet.png")
    static let TOWER        = #imageLiteral(resourceName: "Tower.png")
    static let MARS_SURFACE = #imageLiteral(resourceName: "Mars CH16.png")
    static let NATIVE       = #imageLiteral(resourceName: "chitiniac.png")
}

// Names used by game objects
struct Names {
    static let NATIVE_NAME  = "Native"
    static let BULLET_NAME  = "Bullet"
    static let BASE_NAME    = "Base"
    
    static let TOWER_NAME               = "Tower"
    static let TOWER_SELECTION_CIRCLE   = "Tower Selection Circle"
    static let TOWER_RANGE_CIRCLE       = "Tower Range Circle"
}

// Data associated with the Martian Natives
struct NativeData {
    static let HEALTH           = 1
    static let MOVEMENT_SPEED:CGFloat   = 100
    static let SIZE = CGSize(width: 32, height: 32)
}

// Data associated with the towers
struct TowerData {
    static let RANGE:CGFloat    = 250
    static let DAMAGE   = 3
    static let COOLDOWN:Float = 1
    static let SIZE = CGSize(width: 64, height: 64)
}

// Data associated with the bullets
struct BulletData {
    static let DAMAGE   = 3
    static let MOVEMENT_SPEED:CGFloat = 250.0
    static let SIZE = CGSize(width: 24, height: 24)
}

let FIXED_DELTA_TIME = CGFloat(0.0166666666666666666)

let PI = CGFloat(3.14159265359)
let TWO_PI = PI * 2
let HALF_PI = PI / 2
