//
//  Native.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit

class Native : SKSpriteNode{
    var health:Int!
    var movementSpeed:CGFloat!
    var gameScene:GameScene!

    init(gameScene:GameScene) {
        // Store reference to game scene
        self.gameScene = gameScene
        
        // Get texture
        let texture = SKTexture(image: Sprites.NATIVE)
        
        // Setup data
        health = NativeData.HEALTH
        movementSpeed = NativeData.MOVEMENT_SPEED
        
        super.init(texture: texture, color: UIColor.clear, size: NativeData.SIZE)
        
        self.name = Names.NATIVE_NAME
        
        // Set up physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: NativeData.SIZE.width / 2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.NATIVE
        self.physicsBody?.collisionBitMask = PhysicsCategory.BULLET | PhysicsCategory.BASE
        self.physicsBody?.contactTestBitMask = PhysicsCategory.BULLET | PhysicsCategory.BASE
        
        // Keep native on screen
        self.constraints = [
            SKConstraint.positionX(
                SKRange(lowerLimit: gameScene.frame.minX, upperLimit: gameScene.frame.maxX)
            )]
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
    
    // Movement for the aliens
    func moveTowardsColony() {
        // Get Movement Action
        let action = NativeMovement.GetRandomMovementPattern(native:self)
        
        // Run action
        run(SKAction.repeatForever(action))
    }
}


// Contains SKActions for the movement of the native
struct NativeMovement {
    // Move straight down
    static let MOVE_STRAIGHT_DOWN = SKAction.customAction(withDuration: 1) {
        node, elapsedTime in
        if let native = node as? Native {
            native.position.y = native.position.y + -native.movementSpeed * FIXED_DELTA_TIME
        }
    }
    
    // Move is zig zap pattern
    static let MOVE_ZIG_ZAG = SKAction.customAction(withDuration: 2) {
        node, elapsedTime in
        if let native = node as? Native {
            var movementDelta = CGVector()
            movementDelta.dx = cos(elapsedTime/2 * CGFloat(TWO_PI)) * 5;
            movementDelta.dy = -native.movementSpeed * FIXED_DELTA_TIME
            
            native.position.x = native.position.x + movementDelta.dx
            native.position.y = native.position.y + movementDelta.dy
        }
    }
    
    // Move in charging pattern. (Stop then sprint then stop)
    static let MOVE_CHARGE = SKAction.sequence([
        SKAction.customAction(withDuration: 0.5) {
            node, elapsedTime in
            if let native = node as? Native {
                native.position.y = native.position.y + native.movementSpeed * 0.2 * FIXED_DELTA_TIME
            }
        },
        SKAction.customAction(withDuration: 0.75) {
            node, elapsedTime in
            if let native = node as? Native {
                native.position.y = native.position.y + -native.movementSpeed * 3 * FIXED_DELTA_TIME
            }
        }
        ])
    
    // Move from starting position to a lane, then run down it.
    static func CreateActionFindRandomLane(native:Native) -> SKAction {
        let gameFrame = native.gameScene.frame
        let lane = random(min: gameFrame.minX, max: gameFrame.maxX)
        let enterPoint = random(min: gameFrame.midY, max: gameFrame.maxY)
        let timeDuration =  TimeInterval(sqrt((lane - native.position.x) * (lane - native.position.x) +  (enterPoint - native.position.y) * (enterPoint - native.position.y)) / native.movementSpeed)
        
        let findLane = SKAction.move(to: CGPoint(x: lane, y: enterPoint), duration: timeDuration)
        let travelDownLane = SKAction.repeatForever(NativeMovement.MOVE_STRAIGHT_DOWN)
        
        return SKAction.sequence([findLane, travelDownLane])
    }
    
    // Get random movement action
    static func GetRandomMovementPattern(native:Native) -> SKAction {
        switch random(min: 0, max: 4) {
        case 0:
            return MOVE_STRAIGHT_DOWN
        case 1:
            return MOVE_ZIG_ZAG
        case 2:
            return MOVE_CHARGE
        case 3:
            return CreateActionFindRandomLane(native:native)
        default:
            return MOVE_STRAIGHT_DOWN
        }
    }
}

