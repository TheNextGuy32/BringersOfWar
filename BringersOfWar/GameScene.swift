//
//  GameScene.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var lives:Int!
    var towersLeft:Int!
    var gameTime:Float!
    
    var isPlacingTower:Bool = false;
    
    var towers:[Tower]!
    var bullets:[Bullet]!
    var natives:[Native]!
    
    // User Interface
    var towerButton:SKShapeNode!
    var livesLabel:SKLabelNode!
    var towersLeftLabel:SKLabelNode!
    
    override func didMove(to view: SKView) {
        lives = 3;
        towersLeft = 6;
        gameTime = 0;
        
        towers = [];
        bullets = [];
        natives = [];
        
        setupUserInterface()
        
        startEnemySpawning()
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    // Finds the game objects in the GameScene.sks
    func setupUserInterface() {
        // Tower Placement Button
        towerButton = SKShapeNode(rectOf: CGSize(width: 96, height: 96))
        towerButton.name = "Tower Button"
        towerButton.fillTexture = SKTexture(imageNamed: "Tower.png")
        towerButton.fillColor = SKColor.gray
        towerButton.position = CGPoint(x: self.frame.maxX - 96, y: self.frame.minY + 96)
        towerButton.zPosition = 100
        addChild(towerButton)
        
        // Labels
        livesLabel = childNode(withName: "LivesLabel") as! SKLabelNode
        towersLeftLabel = childNode(withName: "TowersLeftLabel") as! SKLabelNode
        
        livesLabel.text = "Lives Left: " + String(lives)
        towersLeftLabel.text = "Towers Left: " + String(towersLeft)
    }
    
    func startEnemySpawning() {
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
        let native = Native(gameScene: self)
        
        let spawnPointX = random(min: frame.minX, max: frame.maxX)
        
        native.position = CGPoint(x: spawnPointX, y: frame.maxY)
        addChild(native)
        native.moveTowardsColony()
    }
    
    func damageColony() {
        lives = lives - 1
        
        livesLabel.text = "Lives Left: " + String(lives)
        
        if(lives <= 0) {
            restartLevel()
        }
    }
    
    func restartLevel() {
        run(SKAction.sequence([
            SKAction.run() {
                if let scene = SKScene(fileNamed: "GameScene") {
                    let reveal = SKTransition.flipHorizontal(withDuration: 2)
                    scene.scaleMode = .fill
                    self.view?.presentScene(scene, transition:reveal)
                }
            }
            ]))
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
        
        if(isPlacingTower && towersLeft > 0) {
            let tower = Tower(gameScene: self)
            
            tower.position = touchPosition
            addChild(tower)
            
            towers.append(tower)
            
            towersLeft = towersLeft - 1
            
            towersLeftLabel.text = "Towers Left: " + String(towersLeft)
        } else {
            for tower:Tower in towers {
                tower.fireBullet(target: touchPosition)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let spriteNodeA = contact.bodyA.node as? SKSpriteNode
        let spriteNodeB = contact.bodyB.node as? SKSpriteNode
        
        if(spriteNodeA != nil && spriteNodeB != nil) {
            spriteNodeA?.removeFromParent()
            spriteNodeB?.removeFromParent()
        }
    }
}
