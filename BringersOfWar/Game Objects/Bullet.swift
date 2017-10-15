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
    public var direction:CGVector!
    
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
        
        self.direction = CGVector(dx:0,dy:0)
        
        // Set up physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: BulletData.SIZE.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.BULLET
        self.physicsBody?.collisionBitMask = PhysicsCategory.NATIVE
        self.physicsBody?.contactTestBitMask = PhysicsCategory.NATIVE
        
        self.emitter = SKEmitterNode(fileNamed: "bullet")!
        self.emitter.zPosition = CGFloat(BulletData.EMITTER_Z)
        addChild(self.emitter)
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
        
        direction = CGVector(dx:movementVector.dx/length, dy:movementVector.dy/length)
        
        self.emitter.xAcceleration = -(movementVector.dx/length * 1000)
        self.emitter.yAcceleration = -(movementVector.dy/length * 1000)
        
        // Movement action
        run(SKAction.sequence([
                SKAction.move(by: movementVector, duration: movementDuration),
                SKAction.removeFromParent()
            ])
        )
    }
}
