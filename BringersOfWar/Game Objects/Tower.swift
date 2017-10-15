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
    var canFire:Bool!
    var range:CGFloat!
    var damage:Int!
    var cooldown:Float!
    var previousFireTime:TimeInterval!
    
    // UI
    var cooldownCircle:SKShapeNode!
    var selectionCircle:SKShapeNode!
    var rangeCircle:SKShapeNode!
    
    init() {
        // Get texture
        let texture = SKTexture(image: Sprites.TOWER)
        
        // Setup data
        canFire = true
        damage = TowerData.DAMAGE
        range = TowerData.RANGE
        cooldown = TowerData.COOLDOWN
        previousFireTime = TimeInterval(exactly: -cooldown)
        
        // Initiate Base
        super.init(texture: texture, color: UIColor.clear, size: TowerData.SIZE)
        self.name = Names.TOWER_NAME
        
        // Add selection circle
        selectionCircle = SKShapeNode(circleOfRadius: CGFloat(TowerData.SIZE.width))
        selectionCircle.name = Names.TOWER_SELECTION_CIRCLE
        selectionCircle.position = CGPoint(x: 0, y: 0)
        selectionCircle.strokeColor = SKColor.white
        selectionCircle.glowWidth = 1.0
        selectionCircle.fillColor = SKColor.clear
        addChild(selectionCircle)
        
        // Add range circle
        rangeCircle = SKShapeNode(circleOfRadius: CGFloat(range))
        rangeCircle.name = Names.TOWER_RANGE_CIRCLE
        rangeCircle.position = CGPoint(x: 0, y: 0)
        rangeCircle.strokeColor = SKColor.blue
        rangeCircle.glowWidth = 2.0
        rangeCircle.fillColor = SKColor.clear
        addChild(rangeCircle)
        
        // Add cooldown circle
        cooldownCircle = SKShapeNode(circleOfRadius: CGFloat(TowerData.SIZE.width))
        cooldownCircle.name = Names.TOWER_COOLDOWN_CIRCLE
        cooldownCircle.position = CGPoint(x: 0, y: 0)
        cooldownCircle.strokeColor = SKColor.cyan
        cooldownCircle.glowWidth = 1.0
        cooldownCircle.fillColor = SKColor.clear
        self.addChild(cooldownCircle!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    func update(_ currentTime: TimeInterval) {
        let timeSinceLastFire = currentTime - previousFireTime
        canFire = Float(timeSinceLastFire) > cooldown
        
        
        if canFire {
            cooldownCircle.isHidden = true
        } else {
            cooldownCircle.setScale(CGFloat(timeSinceLastFire)/CGFloat(cooldown))
            cooldownCircle.isHidden = false
        }
    }
    
    // Fire bullet at point
    func fireBullet(target:CGPoint) {
        if !canFire {
            return
        }
        
        // Create and fire bullet
        let bullet = Bullet(tower:self)
        bullet.position = self.position;
        self.scene?.addChild(bullet)
        bullet.moveTowardsTarget(target: target)
        
        // Face target
        let vectorTo = vectorToFrom(target, self.position)
        self.zRotation = atan2(vectorTo.dy, vectorTo.dx) - HALF_PI
       
        let laserSound = random(min: 0, max:3)
        GSAudio.sharedInstance.playSound(soundFileName: "machineLaser\(laserSound).wav", volume: 1.0)
     
        previousFireTime = TimeInterval.currentTime
    }
    
    func isPointInRange(_ point: CGPoint) -> Bool {
        return distance(point, self.position) < self.range
    }
}
