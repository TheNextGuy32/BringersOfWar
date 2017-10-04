//
//  LevelResults.swift
//  BringersOfWar
//
//  Created by Oliver Barnum on 10/4/17.
//  Copyright © 2017 StenedoresII. All rights reserved.
//

import Foundation
class LevelResults {
    let levelNum:Int
    let levelScore:Int
    let totalScore:Int
    let msg:String
    init(levelNum:Int, levelScore:Int, totalScore:Int, msg:String) {
        self.levelNum = levelNum
        self.levelScore = levelScore
        self.totalScore = totalScore
        self.msg = msg
    }
}
