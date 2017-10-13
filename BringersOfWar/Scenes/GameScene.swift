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
        
        // Place colony collision
        let colonyColliderRect = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: 192))
        let colonyNode = SKShapeNode(rect: colonyColliderRect)
        colonyNode.name = Names.BASE_NAME
        colonyNode.strokeColor = .green
        colonyNode.physicsBody = SKPhysicsBody(edgeLoopFrom: colonyColliderRect)
        colonyNode.physicsBody?.isDynamic = false
        colonyNode.physicsBody?.affectedByGravity = false
        colonyNode.physicsBody?.categoryBitMask = PhysicsCategory.BASE
        colonyNode.physicsBody?.collisionBitMask = PhysicsCategory.NATIVE
        colonyNode.physicsBody?.contactTestBitMask = PhysicsCategory.NATIVE
        addChild(colonyNode)
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
    
<<<<<<< HEAD:BringersOfWar/Scenes/GameScene.swift
=======
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    
    // Mark: - Collision -
>>>>>>> aa1e2b39ba6ec0f973f942dfb4699067255fda22:BringersOfWar/GameScene.swift
    // Handle collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        print("\(nodeA!.name!) collided with \(nodeB!.name!)")
        
        
        // Check if nodeA is a Native
        if nodeA!.name == Names.NATIVE_NAME {
            handleNativeCollision(nativeNode: nodeA!, otherNode: nodeB!)
        } else if nodeB!.name == Names.NATIVE_NAME {
            handleNativeCollision(nativeNode: nodeB!, otherNode: nodeA!)
        } else {
            print("Unhandled Collision")
        }
    }
    
    // Handle collisions with natives
    private func handleNativeCollision(nativeNode: SKNode, otherNode: SKNode) {
        switch(otherNode.name!) {
        case Names.BULLET_NAME:
            // Bullet Collision. Remove both.
            nativeNode.removeFromParent()
            otherNode.removeFromParent()
            break
        case Names.BASE_NAME:
            // Collision with base. Remove native. damage base
            nativeNode.removeFromParent()
            self.damageColony()
            break;
        default:
            print("Unhandled Collision")
            break
        }
    }
}