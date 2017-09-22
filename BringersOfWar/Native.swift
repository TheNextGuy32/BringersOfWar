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

    init(myHealth:Int!, mySpeed:CGFloat!, imageNamed: String!) {
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        health = myHealth
        speed = mySpeed
    }
    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
}
