//
//  TowerManager.swift
//  BringersOfWar
//
//  Created by student on 10/12/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import SpriteKit
import GameplayKit

import Foundation

class TowerManager {
    let gameScene:GameScene!
    
    var towers:[Tower]!
    
    var towersLeft:Int!
    
    var mode:Mode
    
    enum Mode {
        case TOWER_FIRING
        case TOWER_PLACEMENT
    }
    
    init(gameScene:GameScene) {
        towersLeft = 6
        towers = [Tower]()
        mode = .TOWER_FIRING
        
        self.gameScene = gameScene
    }
    
    public func handlePlayerTouchBegan(position:CGPoint) {
        switch mode {
        case .TOWER_FIRING:
            fireTowersAtPoint(position: position)
            break
        default:
            // Do nothing. Tower placement is handled to touch end.
            break
        }
    }
    
    public func handlePlayerTouchEnd(position:CGPoint) {
        switch mode {
        case .TOWER_PLACEMENT:
            let nodes = gameScene.nodes(at: position)
            for node in nodes {
                if (node.name == Names.TOWER_SELECTION_CIRCLE) {
                    removeTower(tower: node.parent as! Tower)
                    return
                }
            }
            addTower(position: position)
            break
        default:
            // Do nothing. Firing is handled to touch start.
            break
        }
    }
    
    public func toggleActivation() {
        mode = mode == .TOWER_PLACEMENT ? .TOWER_FIRING : .TOWER_PLACEMENT
        
        mode == .TOWER_PLACEMENT ?
            GSAudio.sharedInstance.playSound(soundFileName: "on.wav",volume:1.0):
            GSAudio.sharedInstance.playSound(soundFileName: "off.wav",volume:1.0)
    }
    
    func deactivate() {
        mode = .TOWER_FIRING
    }
    
    // Place a tower at a point
    func addTower(position:CGPoint) {
        // Check if their is a tower remaining.
        if towersLeft <= 0 {
            // TODO: Play Sound "Error"
            return
        }
        
        let tower = Tower(gameScene: self.gameScene)
        
        towers.append(tower)
        
        // Place tower at position
        tower.position = position
        gameScene.addChild(tower)
        
        towersLeft = towersLeft - 1
    }
    
    func removeTower(tower:Tower) {
        if mode != .TOWER_PLACEMENT {
            return
        }
        
        tower.removeFromParent()
        
        towers = towers.filter({$0 != tower})
        
        towersLeft = towersLeft + 1
    }
    
    func fireTowersAtPoint(position:CGPoint) {
        for tower in towers {
            if tower.isPointInRange(position) {
                tower.fireBullet(target: position)
            }
        }
    }
}
