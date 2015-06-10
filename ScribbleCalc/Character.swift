//
//  Character.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 6/10/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation

class ImgCharacter {
    var startRow: Int
    var endRow: Int
    var startCol: Int
    var endCol: Int
    var textCharacter: String
    
    init () {
        startRow = 0
        startCol = 0
        endRow   = 0
        endCol   = 0
        textCharacter = ""
    }
    
    func reset() {
        startRow = 0
        startCol = 0
        endRow   = 0
        endCol   = 0
        textCharacter = ""
    }
}