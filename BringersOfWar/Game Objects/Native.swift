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
        // Store reference to game scene
        self.gameScene = gameScene
        
        // Get texture
        let texture = SKTexture(image: Sprites.NATIVE)
        
        // Setup data
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
    
    // Movement for the aliens
    func moveTowardsColony() {
        // Move towards the colony while checking if we have reached it
        let movementAction = SKAction.run {
            self.position.y = self.position.y + -self.movementSpeed * FIXED_DELTA_TIME
            
            if (self.position.y < self.parent!.frame.minY) {
                // Damage the colony if we reach it.
                self.gameScene.damageColony()
                self.removeFromParent()
            }
        }
        
        // Run action
        run(
            SKAction.repeatForever(
                SKAction.sequence([
                    movementAction,
                    SKAction.wait(forDuration: Double(FIXED_DELTA_TIME))    // Probably not the best way to delay to the next frame
                ])
            )
        )
    }
}
