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
    // Game Vars
    var lives:Int!
    var towersLeft:Int!
    var gameTime:Float!
    
    // UI mode
    var isPlacingTower:Bool = false;
    
    // Game objects
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
        
        // Setup physics in scene
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
        
        // Get labels from .sks
        livesLabel = childNode(withName: "LivesLabel") as! SKLabelNode
        towersLeftLabel = childNode(withName: "TowersLeftLabel") as! SKLabelNode
        
        livesLabel.text = "Lives Left: " + String(lives)
        towersLeftLabel.text = "Towers Left: " + String(towersLeft)
    }
    
    // Handle enemy spawning
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

    // Add enemy to field
    func addEnemy() {
        let native = Native(gameScene: self)
        
        let spawnPointX = random(min: frame.minX, max: frame.maxX)
        
        native.position = CGPoint(x: spawnPointX, y: frame.maxY)
        addChild(native)
        native.moveTowardsColony()
    }
    
    // Damage the player
    func damageColony() {
        lives = lives - 1
        
        // Set label. TODO: Handle this with didSet
        livesLabel.text = "Lives Left: " + String(lives)
        
        if(lives <= 0) {
            restartLevel()
        }
    }
    
    // Restart level
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
        
        // Check if we are in placing mode
        if(isPlacingTower && towersLeft > 0) {
            let tower = Tower(gameScene: self)
            
            // Place tower
            tower.position = touchPosition
            addChild(tower)
            towers.append(tower)
            
            towersLeft = towersLeft - 1
            
            // TODO: Handle this in didSet
            towersLeftLabel.text = "Towers Left: " + String(towersLeft)
        } else {
            // Fire the tower bullets
            for tower:Tower in towers {
                tower.fireBullet(target: touchPosition)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    // Handle collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let spriteNodeA = contact.bodyA.node as? SKSpriteNode
        let spriteNodeB = contact.bodyB.node as? SKSpriteNode
        
        // Assume that we want to delete these
        if(spriteNodeA != nil && spriteNodeB != nil) {
            spriteNodeA?.removeFromParent()
            spriteNodeB?.removeFromParent()
        }
    }
}
