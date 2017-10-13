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
        case Fire_Towers
        case Placing_Tower
        case Remove_Tower
    }
    
    init(gameScene:GameScene) {
        towersLeft = 6
        towers = [Tower]()
        mode = .Fire_Towers
        
        self.gameScene = gameScene
    }
    
    func deactivate() {
        mode = .Fire_Towers
    }
    
    // Place a tower at a point
    func addTower(position:CGPoint) {
        // Check if their is a tower remaining.
        if mode != .Placing_Tower && towersLeft <= 0 {
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
        if mode != .Remove_Tower {
            return
        }
        
        tower.removeFromParent()
        
        towers = towers.filter({$0 != tower})
    }
    
    func fireTowersAtPoint(position:CGPoint) {
        for tower:Tower in towers {
        }
    }
}
