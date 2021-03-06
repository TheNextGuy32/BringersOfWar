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
    var damage:Int!
    var radius:Float!
    var movementSpeed:CGFloat!
    var tower:Tower!
    
    init(tower:Tower) {
        // Store reference to associated tower
        self.tower = tower
        
        // Get texture
        let texture = SKTexture(image: Sprites.BULLET)
        
        // Setup data
        damage = BulletData.DAMAGE
        movementSpeed = BulletData.MOVEMENT_SPEED
        
        super.init(texture: texture, color: UIColor.clear, size: BulletData.SIZE)
        self.name = Names.BULLET_NAME
        
        // Set up physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: BulletData.SIZE.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.BULLET
        self.physicsBody?.collisionBitMask = PhysicsCategory.NATIVE
        self.physicsBody?.contactTestBitMask = PhysicsCategory.NATIVE
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    // Move bullet towards target
    public func moveTowardsTarget(target:CGPoint) {
        var movementVector = vectorToFrom(target, self.position)
        let length = max(movementVector.getMagnitude(), tower.range)
        movementVector.setMagnitude(length)
        let movementDuration = TimeInterval(Double(length / movementSpeed))
        
        // Movement action
        run(SKAction.sequence([
                SKAction.move(by: movementVector, duration: movementDuration),
                SKAction.removeFromParent()
            ])
        )
    }
}
