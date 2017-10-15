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
    let scene:SKScene!
    
    var towers:[Tower]!
    
    var towersLeft:Int! {
        didSet {
            onTowerCountChanged?(towersLeft)
        }
    }
    var onTowerCountChanged: ((_ towersLeft:Int) -> Void)?
    
    enum Mode {
        case TOWER_FIRING
        case TOWER_PLACEMENT
    }
    var mode:Mode {
        didSet{
            onModeSet?(mode)
        }
    }
    var onModeSet: ((_ mode:Mode) -> Void)?
    
    
    init(scene:SKScene) {
        towersLeft = 6
        towers = [Tower]()
        mode = .TOWER_FIRING
        
        self.scene = scene
    }
    
    public func updateTowers(_ currentTime: TimeInterval) {
        for tower in towers {
            tower.update(currentTime)
        }
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
            let nodes = scene.nodes(at: position)
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
        
        let tower = Tower()
        
        towers.append(tower)
        
        // Place tower at position
        tower.position = position
        scene.addChild(tower)
        
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
