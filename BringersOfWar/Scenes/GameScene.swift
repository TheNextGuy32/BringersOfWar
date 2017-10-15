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
    
    var levelNum:Int!
    var levelScore:Int! = 0
    var totalScore:Int!
    
    var sceneManager:GameViewController!
    var towerManager:TowerManager!
    
    var playableRect = CGRect.zero
    
    // Game Vars
    var lives:Int! {
        didSet {
            livesLabel.text = "Lives left: \(lives)"
        }
    }
    
    // UI mode
    var isPlacingTower:Bool = false;
    var towerButton:SKShapeNode!
    
  
    
    // User Interface
    var livesLabel = SKLabelNode()
    var towerLabel = SKLabelNode()
    
    init(size: CGSize, scaleMode: SKSceneScaleMode, levelNum:Int, totalScore:Int, sceneManager:GameViewController) {
        super.init(size: size)
        
        // Set up Managers
        self.sceneManager = sceneManager
        self.towerManager = TowerManager(scene:self)
        
        self.levelNum = levelNum
        self.totalScore = totalScore
        
        self.lives = 3
        
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
        
        GSAudio.sharedInstance.playSound(soundFileName: "mars.wav",volume:0.2)
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
        towerManager.onModeSet = { (mode:TowerManager.Mode) in
            self.towerButton.fillColor = mode == .TOWER_PLACEMENT ? SKColor.green : SKColor.gray
        }
        
        livesLabel.text = "Lives Left: \(lives!)"
        livesLabel.fontColor  = SKColor.red
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.minY + 40)
        livesLabel.zPosition = 100
        addChild(livesLabel)
        
        towerLabel.text = "Towers Left: \(towerManager.towersLeft!)"
        towerLabel.fontColor = SKColor.red
        towerLabel.verticalAlignmentMode = .bottom
        towerLabel.horizontalAlignmentMode = .left
        towerLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.minY + 96)
        towerLabel.zPosition = 100
        addChild(towerLabel)
        towerManager.onTowerCountChanged = { (towersLeft) in
            self.towerLabel.text = "Towers Left: \(towersLeft)"
        }
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
            GSAudio.sharedInstance.playSound(soundFileName: "loser.wav",volume:1.0)
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
    
    override func update(_ currentTime: TimeInterval) {
        TimeInterval.currentTime = currentTime
        towerManager?.updateTowers(currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if touch works
        guard let touch = touches.first else {
            return
        }
        
        // Find touch position
        let touchPosition = touch.location(in: self)
        
        towerManager.handlePlayerTouchBegan(position: touchPosition)
    }
    
    // Hanlde touches ending
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if touch works
        guard let touch = touches.first else {
            return
        }
        
        // Find touch position
        let touchPosition = touch.location(in: self)
        
        // Check if tower button is pressed
        if let node = self.nodes(at: touchPosition).first {
            if(node.name == towerButton.name) {
                towerManager.toggleActivation()
                return
            }
        }
        
        towerManager.handlePlayerTouchEnd(position: touchPosition)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            print("\(nodeA.name ?? "No Name") collided with \(nodeB.name ?? "No Name")")
            
            // Check if nodeA is a Native
            if nodeA.name == Names.NATIVE_NAME {
                handleNativeCollision(nativeNode: nodeA, otherNode: nodeB)
            } else if nodeB.name == Names.NATIVE_NAME {
                handleNativeCollision(nativeNode: nodeB, otherNode: nodeA)
            } else {
                print("Unhandled Collision")
            }
        }
    }
    
    // Handle collisions with natives
    private func handleNativeCollision(nativeNode: SKNode, otherNode: SKNode) {
        switch(otherNode.name!) {
        case Names.BULLET_NAME:
            // Bullet Collision. Remove both.
            let deathSound = random(min: 0, max:1)
            GSAudio.sharedInstance.playSound(soundFileName: "splish\(deathSound).wav",volume:0.2)
            nativeNode.removeFromParent()
            otherNode.removeFromParent()
            break
        case Names.BASE_NAME:
            // Collision with base. Remove native. damage base
            nativeNode.removeFromParent()
            self.damageColony()
            GSAudio.sharedInstance.playSound(soundFileName: "base.wav",volume:0.9)
            break;
        default:
            print("Unhandled Collision")
            break
        }
    }
}
