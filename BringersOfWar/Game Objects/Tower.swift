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
    var range:CGFloat!
    var damage:Int!
    var cooldown:Float!
    var cooldownTimer:Float!
    var gameScene:GameScene!
    
    init(gameScene:GameScene) {
        // Store reference to game scene
        self.gameScene = gameScene
        
        // Get texture
        let texture = SKTexture(image: Sprites.TOWER)
        
        // Setup data
        damage = TowerData.DAMAGE
        range = TowerData.RANGE
        cooldown = TowerData.COOLDOWN
        cooldownTimer = 0
        
        // Initiate Base
        super.init(texture: texture, color: UIColor.clear, size: TowerData.SIZE)
        self.name = Names.TOWER_NAME
        
        // Add range circle
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
    
    // Fire bullet at point
    func fireBullet(target:CGPoint) {
        let vectorBetween:CGVector = CGVector(dx: target.x - self.position.x, dy: target.y - self.position.y)
        let length = sqrt(vectorBetween.dx * vectorBetween.dx + vectorBetween.dy * vectorBetween.dy)
        
        // Check if point is in range
        if (length <= range) {
            // Create and fire bullet
            let bullet = Bullet(tower:self)
            bullet.position = self.position;
            gameScene.addChild(bullet)
            bullet.moveTowardsTarget(target: target)
        }
    }
}
