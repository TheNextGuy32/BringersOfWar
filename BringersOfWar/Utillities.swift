//
//  Utillities.swift
//  BringersOfWar
//
//  Created by student on 9/25/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
import SpriteKit

// Time
extension TimeInterval {
    static var currentTime:TimeInterval = 0
}
func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func random(min: Int, max: Int) -> Int {
    return Int(random() * CGFloat(max - min)) + min
}

func clamp(_ value: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat{
    return min(max(value, minValue), maxValue)
}

// Vector between points
func vectorToFrom(_ to: CGPoint, _ from: CGPoint) -> CGVector {
    return CGVector(dx: to.x - from.x, dy: to.y - from.y)
}

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let vectorBetween = vectorToFrom(a, b)
    return sqrt(vectorBetween.dx * vectorBetween.dx + vectorBetween.dy * vectorBetween.dy)
}

extension CGVector{
    func getMagnitude() -> CGFloat {
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }
    
    func getMagnitudeSquare() -> CGFloat {
        return self.dx * self.dx + self.dy * self.dy
    }
    
    mutating func setMagnitude(_ newMagnitude: CGFloat) {
        let magnitude = self.getMagnitude()
        
        self.dx = self.dx / magnitude * newMagnitude
        self.dy = self.dy / magnitude * newMagnitude
    }
}
