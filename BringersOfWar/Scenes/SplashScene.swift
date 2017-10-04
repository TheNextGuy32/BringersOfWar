//
//  SplashScrene.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 10/3/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit
class SplashScene: SKScene {
    // MARK: - ivars -
    let sceneManager:GameViewController
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var timeUntilMenu:CGFloat = 0.02
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode:SKSceneScaleMode, sceneManager:GameViewController) {
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    override func didMove(to view: SKView){
        backgroundColor = GameData.scene.backgroundColor
        
        let mars = SKSpriteNode(imageNamed: "mars.jpg")
        mars.name = "mars"
        mars.xScale = 0.6
        mars.yScale = 0.6
        mars.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mars.zPosition = 1
        addChild(mars)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        timeUntilMenu -= FIXED_DELTA_TIME
        if timeUntilMenu < 0 {
            //  Launch game scene
            sceneManager.loadMenuScene()
        }
        
    }
    
}

