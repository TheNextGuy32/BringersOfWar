//
//  Utillities.swift
//  BringersOfWar
//
//  Created by student on 9/25/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func random(min: Int, max: Int) -> Int {
    return Int(random() * CGFloat(max - min)) + min
}

// Vector between points
func vectorBetween(_ a: CGPoint, _ b: CGPoint) -> CGVector {
    return CGVector(dx: a.x - b.x, dy: a.y - b.y)
}

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let vector = vectorBetween(a, b)
    return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
}

