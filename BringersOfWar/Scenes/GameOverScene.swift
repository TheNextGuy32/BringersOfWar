//
//  GameOverScene.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 10/4/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit
class GameOverScene: SKScene {
    // MARK: - ivars -
    let sceneManager:GameViewController
    let score:Int
    let button:SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont)
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode:SKSceneScaleMode, score:Int, sceneManager:GameViewController) {
        self.score = score
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func didMove(to view: SKView){
        backgroundColor = GameData.scene.backgroundColor
        
        let label0 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label0.text = "Game Over"
        label0.fontSize = 150
        label0.position = CGPoint(x:size.width/2, y:size.height/2 + 200)
        addChild(label0)
        
        let label1 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label1.text = "You got \(score) total diamonds!"
        label1.fontSize = 70
        label1.position = CGPoint(x:size.width/2, y:size.height/2 - 100)
        addChild(label1)
        
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label2.text = "Tap to return to Menu"
        label2.fontColor = UIColor.red
        label2.fontSize = 70
        label2.position = CGPoint(x:size.width/2, y:size.height/2 - 400)
        addChild(label2)
    }
    
    // MARK: - Events -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadMenuScene()   
    }
}

