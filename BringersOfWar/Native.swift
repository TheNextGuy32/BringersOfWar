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

    init() {
        let texture = SKTexture(image: Sprites.NATIVE)
        health = NativesData.HEALTH
        movementSpeed = NativesData.MOVEMENT_SPEED
        
        
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    func Move() {
        self.position.y = self.position.y + -self.movementSpeed * FIXED_DELTA_TIME
    }
    
    func MoveTowardsColony() {
        
        let movementAction = SKAction.run {
            self.position.y = self.position.y + -self.movementSpeed * FIXED_DELTA_TIME
            
            if (self.position.y < self.parent!.frame.minY) {
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
