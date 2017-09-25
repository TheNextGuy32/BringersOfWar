//
//  GameScene.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var lives:Int!
    var gameTime:Float!
    var towerButton:SKShapeNode!
    
    var isPlacingTower:Bool = false;
    
    var towers:[Tower]!
    var bullets:[Bullet]!
    var natives:[Native]!
    
    override func didMove(to view: SKView) {
        lives = 3;
        gameTime = 0;
        
        // UI Button
        towerButton = SKShapeNode(rectOf: CGSize(width: 96, height: 96))
        towerButton.name = "Tower Button"
        towerButton.fillTexture = SKTexture(imageNamed: "Tower.png")
        towerButton.fillColor = SKColor.gray
        towerButton.position = CGPoint(x: self.frame.maxX - 96, y: self.frame.minY + 96)
        towerButton.zPosition = 100
        addChild(towerButton)
        
        towers = [];
        bullets = [];
        natives = [];
        
        StartEnemySpawning()
    }
    
    func StartEnemySpawning() {
        run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addEnemy),
                    SKAction.wait(forDuration: 2.5)
                ])
            )
        )
    }

    
    func addEnemy() {
        let native = Native()
        
        let spawnPointX = random(min: frame.minX, max: frame.maxX)
        
        native.position = CGPoint(x: spawnPointX, y: frame.maxY)
        addChild(native)
        native.MoveTowardsColony()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchPosition = touch.location(in: self)
        let node = self.nodes(at: touchPosition).first
        
        // Check if tower button is pressed
        if node != nil {
            let name = node?.name
            
            if(name == towerButton.name) {
                isPlacingTower = !isPlacingTower
                
                towerButton.fillColor = isPlacingTower ? SKColor.green : SKColor.gray
                return
            }
        }
        
        if(isPlacingTower) {
            let tower = Tower(myDamage: 3, myRange: 250, myCooldown: 1, imageNamed: "Tower.png")
            
            tower.position = touchPosition
            addChild(tower)
            
            towers.append(tower)
        } else {
            for tower:Tower in towers {
                let distance = hypot(tower.position.x - position.x, tower.position.y - position.y)
                
                if(distance < CGFloat(tower.range)) {
                    let bullet = Bullet(myDamage: tower.damage, mySpeed: 128, imageNamed: "Bullet.png")
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
