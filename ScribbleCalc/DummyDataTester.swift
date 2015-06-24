//
//  DummyDataTester.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 6/23/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation

class DummyDataTest {
    var dummyTestRows: [[Int]]
    
    init() {
        let csvContents = getContentsOfCSV(testingSource, false)
        self.dummyTestRows = csvContents.rows
        
        println("Got \(dummyTestRows.count) from dummy csv data")

    }
    
    func makePixelRows() {
        var newPixelRow = [PixelData]()
        var rows = [[PixelData]]()
        let manipulator = PhotoManipulator()
        for row in dummyTestRows {
            for (var j = 0; j < row.count; j++) {
                let newPixel = PixelData(value: row[j])
                newPixelRow.append(newPixel)
            }
            return rows.append(newPixelRow)
        }
    }
    
    func getRandom() -> [Int]{
        
        return self.dummyTestRows.randomItem()
    }
}