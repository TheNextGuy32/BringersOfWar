//
//  Tower.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit
class Tower : SKSpriteNode{
    
    var range:Float!
    var damage:Float!
    
    var cooldown:Float!
    var cooldownTimer:Float!
    
    init(myDamage:Float!, myRange:Float!, myCooldown:Float!, imageNamed: String!) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        damage = myDamage
        range = myRange
        cooldown = myCooldown
        cooldownTimer = 0
    }
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
}
