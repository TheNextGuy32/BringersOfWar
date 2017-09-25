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
        
        self.gameScene = gameScene
        
        let texture = SKTexture(image: Sprites.TOWER)
        
        damage = TowerData.DAMAGE
        range = TowerData.RANGE
        cooldown = TowerData.COOLDOWN
        cooldownTimer = 0
        
        super.init(texture: texture, color: UIColor.clear, size: TowerData.SIZE)
        
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
    
    func fireBullet(target:CGPoint) {
        let vectorBetween:CGVector = CGVector(dx: target.x - self.position.x, dy: target.y - self.position.y)
        let length = sqrt(vectorBetween.dx * vectorBetween.dx + vectorBetween.dy * vectorBetween.dy)
        
        if (length <= range) {
            let bullet = Bullet(tower:self)
            bullet.position = self.position;
            gameScene.addChild(bullet)
            bullet.moveTowardsTarget(target: target)
        }
    }
}
