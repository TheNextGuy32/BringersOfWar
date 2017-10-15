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
    
    var score:Int = 0
    var sceneManager:GameViewController!
    var towerManager:TowerManager!
    
    var playableRect = CGRect.zero
    
    // Game Vars
    var lives:Int! {
        didSet {
            livesLabel.text = "Lives left: \(lives)"
        }
    }
    var towersLeft:Int! {
        didSet {
            towerLabel.text = "Towers left: \(towersLeft)"
        }
    }
    
    //
    
    // UI mode
    var isPlacingTower:Bool = false;
    var towerButton:SKShapeNode!
    
    // User Interface
    var livesLabel = SKLabelNode()
    var towerLabel = SKLabelNode()

    init(size: CGSize, scaleMode: SKSceneScaleMode, sceneManager:GameViewController) {
        super.init(size: size)
        
        // Set up Managers
        self.sceneManager = sceneManager
        self.towerManager = TowerManager(gameScene:self)
    
        
        self.lives = 3
        self.towersLeft = 6
        
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
        let colonyColliderRect = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: ColonyData.HEIGHT))
        let colonyNode = SKShapeNode(rect: colonyColliderRect)
        colonyNode.zPosition = ColonyData.Z
        colonyNode.name = Names.BASE_NAME
        colonyNode.strokeColor = .darkGray
        colonyNode.fillColor = .darkGray
        colonyNode.physicsBody = SKPhysicsBody(edgeLoopFrom: colonyColliderRect)
        colonyNode.physicsBody?.isDynamic = false
        colonyNode.physicsBody?.affectedByGravity = false
        colonyNode.physicsBody?.categoryBitMask = PhysicsCategory.BASE
        colonyNode.physicsBody?.collisionBitMask = PhysicsCategory.NATIVE
        colonyNode.physicsBody?.contactTestBitMask = PhysicsCategory.NATIVE
        addChild(colonyNode)
        
        GSAudio.sharedInstance.playSound(soundFileName: "mars.wav",volume:0.3)
    }
    
    // Finds the game objects in the GameScene.sks
    func setupUserInterface() {
        
        for y in 0...25 {
            for x in 0...25 {
                let earth = SKSpriteNode(imageNamed: "earth.png")
                earth.anchorPoint = CGPoint(x:0,y:0)
                earth.position = CGPoint(x: x * 512, y: y * 512)
                earth.zPosition = -10
                addChild(earth)
            }
        }
        
        // Tower Placement Button
        towerButton = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        towerButton.name = "Tower Button"
        towerButton.fillTexture = SKTexture(imageNamed: "Tower.png")
        towerButton.fillColor = SKColor.white
        towerButton.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 50)
        towerButton.zPosition = 100
        addChild(towerButton)
        
        livesLabel.text = "Lives Left: \(lives)"
        livesLabel.fontColor  = SKColor.red
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 50)
        livesLabel.zPosition = 100
        addChild(livesLabel)
        
        towerLabel.text = "Towers left: \(towersLeft)"
        towerLabel.fontColor = SKColor.red
        towerLabel.verticalAlignmentMode = .bottom
        towerLabel.horizontalAlignmentMode = .left
        towerLabel.position = CGPoint(x: self.frame.minX + 200, y: self.frame.minY + 50)
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
        native.zPosition = NativeData.Z
        addChild(native)
        native.moveTowardsColony()
    }
    
    // Damage the player
    func damageColony() {
        lives = lives - 1
        
        if(lives <= 0) {
            GSAudio.sharedInstance.stopSounds()
            GSAudio.sharedInstance.playSound(soundFileName: "loser.wav",volume:1.0)
            sceneManager.loadGameOverScene(score: score)
        }
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if touch works
        guard let touch = touches.first else {
            return
        }
        
        // Find touch position
        let touchPosition = touch.location(in: self)
        if touchPosition.y > ColonyData.HEIGHT {
            towerManager.handlePlayerTouchBegan(position: touchPosition)
        }
    }
    
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

                towerButton.fillColor = towerManager.mode == .TOWER_PLACEMENT ? SKColor.green : SKColor.gray
                return
            }
        }
        if touchPosition.y > ColonyData.HEIGHT {
          towerManager.handlePlayerTouchEnd(position: touchPosition)
        }
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
            
            score += 10
            
            let blood = SKEmitterNode(fileNamed: "blood")!
            blood.position = nativeNode.position
            let bullet = otherNode as! Bullet
            blood.emissionAngle = atan2(bullet.direction.dy,bullet.direction.dx)
//            blood.zPosition = CGFloat(BulletData.EMITTER_Z)
            addChild(blood)
        
            let kill = SKAction.sequence([
                SKAction.wait(forDuration: 0.2),
                SKAction.run {blood.particleBirthRate = 0},
                SKAction.wait(forDuration: 0.2),
                SKAction.run {blood.removeFromParent()}
                ])
            run(kill)
            
            nativeNode.removeFromParent()
            otherNode.removeFromParent()
            break
        case Names.BASE_NAME:
            // Collision with base. Remove native. damage base
            
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            explosion.position = nativeNode.position
//            explosion.zPosition = CGFloat(BulletData.EMITTER_Z)
            addChild(explosion)
            
            let kill = SKAction.sequence([
                SKAction.wait(forDuration: 0.2),
                SKAction.run {explosion.particleBirthRate = 0},
                SKAction.wait(forDuration: 0.2),
                SKAction.run {explosion.removeFromParent()}
                ])
            run(kill)
            
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
