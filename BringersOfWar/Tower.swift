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
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 64, height: 64))
        
        damage = myDamage
        range = myRange
        cooldown = myCooldown
        cooldownTimer = 0
        
        let rangeCircle = SKShapeNode(circleOfRadius: CGFloat(range))
        rangeCircle.position = CGPoint(x: 0, y: 0)
        rangeCircle.strokeColor = SKColor.blue
        rangeCircle.glowWidth = 4.0
        rangeCircle.fillColor = SKColor.clear
        self.addChild(rangeCircle)
    }
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
}
