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
        self.tower = tower
        
        let texture = SKTexture(image: Sprites.BULLET)
        
        damage = BulletData.DAMAGE
        movementSpeed = BulletData.MOVEMENT_SPEED
        
        super.init(texture: texture, color: UIColor.clear, size: BulletData.SIZE)
        
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
    
    public func moveTowardsTarget(target:CGPoint) {
        let vectorBetween:CGVector = CGVector(dx: target.x - self.position.x, dy: target.y - self.position.y)
        let length = sqrt(vectorBetween.dx * vectorBetween.dx + vectorBetween.dy * vectorBetween.dy)

        run(SKAction.sequence([
                SKAction.move(by: vectorBetween, duration: TimeInterval(Double(length / movementSpeed))),
                SKAction.removeFromParent()
            ])
        )
    }
}