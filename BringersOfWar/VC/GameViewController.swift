//
//  GameViewController.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 9/22/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var gameScene: GameScene?
    var skView: SKView!
    let showDebugData = true
    let screenSize = CGSize(width:1080, height:1920)
    let scaleMode = SKSceneScaleMode.aspectFit
    
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = self.view as! SKView
        loadSplashScene()
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = showDebugData
        skView.showsNodeCount = showDebugData
        
        becomeFirstResponder()
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func loadSplashScene() {
        let scene = SplashScene(size:screenSize, scaleMode:scaleMode, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 0.8)
        skView.presentScene(scene, transition:reveal)
    }
    
    func loadMenuScene() {
        let scene = MenuScene(size:screenSize, scaleMode:scaleMode, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 1)
        skView.presentScene(scene, transition:reveal)
    }
    
    func loadGameScene(levelNum: Int, totalScore: Int) {
        gameScene = GameScene(size: screenSize, scaleMode: scaleMode, levelNum: levelNum, totalScore: totalScore, sceneManager: self)
        
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1)
        skView.presentScene(gameScene!, transition: reveal)
    }
}
