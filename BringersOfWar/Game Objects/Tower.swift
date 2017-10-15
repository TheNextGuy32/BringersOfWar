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
        
        // Add selection circle
        let selectionCircle = SKShapeNode(circleOfRadius: CGFloat(TowerData.SIZE.width))
        selectionCircle.name = Names.TOWER_SELECTION_CIRCLE
        selectionCircle.position = CGPoint(x: 0, y: 0)
        selectionCircle.strokeColor = SKColor.white
        selectionCircle.glowWidth = 0.5
        selectionCircle.fillColor = SKColor.clear
        selectionCircle.zPosition = TowerData.SELECTION_Z
        self.addChild(selectionCircle)
        
        // Add range circle
        let rangeCircle = SKShapeNode(circleOfRadius: CGFloat(range))
        rangeCircle.name = Names.TOWER_RANGE_CIRCLE
        rangeCircle.position = CGPoint(x: 0, y: 0)
        rangeCircle.strokeColor = SKColor.blue
        rangeCircle.glowWidth = 2.0
        rangeCircle.fillColor = SKColor.clear
        rangeCircle.zPosition = TowerData.SELECTION_Z
        self.addChild(rangeCircle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    // Fire bullet at point
    func fireBullet(target:CGPoint) {
        // Create and fire bullet
        let bullet = Bullet(tower:self)
        bullet.position = self.position
        bullet.zPosition = BulletData.Z
        gameScene.addChild(bullet)
        bullet.moveTowardsTarget(target: target)
        
        // Face target
        let vectorTo = vectorToFrom(target, self.position)
        self.zRotation = atan2(vectorTo.dy, vectorTo.dx) - HALF_PI
       
        let laserSound = random(min: 0, max:3)
        GSAudio.sharedInstance.playSound(soundFileName: "machineLaser\(laserSound).wav", volume: 1.0)
     
        
    }
    
    func isPointInRange(_ point: CGPoint) -> Bool {
        return distance(point, self.position) < self.range
    }
}
