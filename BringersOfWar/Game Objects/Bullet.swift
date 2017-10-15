//
//  Bullet.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit
class Bullet : SKSpriteNode {
    var emitter:SKEmitterNode!
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
        
        self.emitter = SKEmitterNode(fileNamed: "bullet")!
        addChild(self.emitter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    // Move bullet towards target
    public func moveTowardsTarget(target:CGPoint) {
        let vectorBetween:CGVector = CGVector(dx: target.x - self.position.x, dy: target.y - self.position.y)
        let length = sqrt(vectorBetween.dx * vectorBetween.dx + vectorBetween.dy * vectorBetween.dy)
    
        self.emitter.xAcceleration = -(vectorBetween.dx/length * 1000)
        self.emitter.yAcceleration = -(vectorBetween.dy/length * 1000)
        // Movement action
        run(SKAction.sequence([
                SKAction.move(by: vectorBetween, duration: TimeInterval(Double(length / movementSpeed))),
                SKAction.removeFromParent()
            ])
        )
    }
}
