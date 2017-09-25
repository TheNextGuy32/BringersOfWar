//
//  Native.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit

class Native : SKSpriteNode{
    var health:Int!
    var movementSpeed:CGFloat!
    var gameScene:GameScene!

    init(gameScene:GameScene) {
        self.gameScene = gameScene
        
        let texture = SKTexture(image: Sprites.NATIVE)
        health = NativeData.HEALTH
        movementSpeed = NativeData.MOVEMENT_SPEED
        
        super.init(texture: texture, color: UIColor.clear, size: NativeData.SIZE)
        
        // Set up physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: NativeData.SIZE.width / 2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.NATIVE
        self.physicsBody?.collisionBitMask = PhysicsCategory.BULLET
        self.physicsBody?.contactTestBitMask = PhysicsCategory.BULLET
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    func moveTowardsColony() {
        let movementAction = SKAction.run {
            self.position.y = self.position.y + -self.movementSpeed * FIXED_DELTA_TIME
            
            if (self.position.y < self.parent!.frame.minY) {
                self.gameScene.damageColony()
                self.removeFromParent()
            }
        }
        
        run(
            SKAction.repeatForever(
                SKAction.sequence([
                    movementAction,
                    SKAction.wait(forDuration: Double(FIXED_DELTA_TIME))
                ])
            )
        )
    }
}
