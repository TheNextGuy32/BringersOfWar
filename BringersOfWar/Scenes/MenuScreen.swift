//
//  HomeScreen.swift
//  Shooter
//
//  Created by Oliver Barnum on 9/28/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let sceneManager: GameViewController
    let button:SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont)
    
    init(size: CGSize, scaleMode: SKSceneScaleMode, sceneManager: GameViewController) {
        self.sceneManager = sceneManager
        
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("It done gone run unfixed itself Colonel!")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        GSAudio.sharedInstance.playSound(soundFileName: "menu.wav", volume:1.0)
        sceneManager.loadGameScene()
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = GameData.scene.backgroundColor
        
        let mars = SKSpriteNode(imageNamed: "mars.jpg")
        mars.name = "mars"
        mars.xScale = 0.6
        mars.yScale = 0.6
        mars.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mars.zPosition = 0
        addChild(mars)
        
        let label0 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label0.text = "Bringer of War"
        label0.fontSize = 90
        label0.position = CGPoint(x: size.width/2, y: size.height/2 + 400)
        label0.zPosition = 1
        addChild(label0)
        
        let label1 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label1.text = "Start!"
        label1.fontSize = 70
        label1.fontColor = UIColor.red
        label1.position = CGPoint(x: size.width/2, y: size.height/2 - 400)
        label1.zPosition = 1
        addChild(label1)
    }
}


