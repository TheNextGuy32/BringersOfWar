//
//  Bullet.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit
class Bullet : SKSpriteNode{
    
    var damage:Float!
    var radius:Float!
    
    init(myDamage:Float!, mySpeed:CGFloat!, imageNamed: String!) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 32, height: 32))
        
        damage = myDamage
        speed = mySpeed
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 32)
        
        // Set up physics
        physicsBody?.categoryBitMask = PhysicsCategory.BULLET
        physicsBody?.collisionBitMask = PhysicsCategory.NATIVE
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    public func fire(_ startLocation: CGPoint, _ direction: CGVector, _ range:CGFloat) {
        var distance:CGFloat!
        SKAction.run {
            distance = hypot(self.position.x - startLocation.x, self.position.y - startLocation.y)
            if(distance > range) {
                self.removeFromParent()
                self.removeAction(forKey: "move")
                return
            }
            
        }
    }
}
