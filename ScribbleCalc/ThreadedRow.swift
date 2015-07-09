//
//  ThreadedRow.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 7/8/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation

struct ThreadedRow {
    var id: Int
    var row: [[Int]]
    var label: [String]
    
    init(id: Int, row: [Int]) {
        self.id = id
        self.row = [row]
        self.label = [String]()
    }
}