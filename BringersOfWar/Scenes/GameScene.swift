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
    
    var levelNum:Int
    var levelScore:Int = 0
    var totalScore:Int
    
    let sceneManager:GameViewController
    
    var playableRect = CGRect.zero
    
    // Game Vars
    var lives:Int {
        didSet {
            livesLabel.text = "Lives left: \(lives)"
        }
    }
    var towersLeft:Int {
        didSet {
            towerLabel.text = "Towers left: \(towersLeft)"
        }
    }
    
    // UI mode
    var isPlacingTower:Bool = false;
    var towerButton:SKShapeNode!
    
    // Game objects
    var towers:[Tower]!
    var bullets:[Bullet]!
    var natives:[Native]!
    
    // User Interface
    var livesLabel = SKLabelNode()
    var towerLabel = SKLabelNode()
    
    init(size: CGSize, scaleMode: SKSceneScaleMode, levelNum:Int, totalScore:Int, sceneManager:GameViewController) {
        
        self.levelNum = levelNum
        self.totalScore = totalScore
        self.sceneManager = sceneManager
        
        self.lives = 3
        self.towersLeft = 6
        
        towers = []
        bullets = []
        natives = []
        
        super.init(size: size)
        
        self.scaleMode = scaleMode
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("It done gone fucked up Sarge!")
    }
    
    override func didMove(to view: SKView) {
        
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
        towerButton.fillColor = SKColor.white
        towerButton.position = CGPoint(x: self.frame.maxX - 96, y: self.frame.minY + 96)
        towerButton.zPosition = 100
        addChild(towerButton)
        
        livesLabel.text = "Lives Left: \(lives)"
        livesLabel.fontColor  = SKColor.red
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.minY + 40)
        livesLabel.zPosition = 100
        addChild(livesLabel)
        
        towerLabel.text = "Towers left: \(towersLeft)"
        towerLabel.fontColor = SKColor.red
        towerLabel.verticalAlignmentMode = .bottom
        towerLabel.horizontalAlignmentMode = .left
        towerLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.minY + 96)
        towerLabel.zPosition = 100
        addChild(towerLabel)
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
            
        } else {
            // Fire the tower bullets
            for tower:Tower in towers {
                tower.fireBullet(target: touchPosition)
            }
        }
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
