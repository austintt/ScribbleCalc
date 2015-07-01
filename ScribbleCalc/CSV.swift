//
//  CSV.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 5/21/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation



/****************************************************************************
* GET CONTENTS OF CSV
*
* Reads a CSV file in to a 2D array. First demension specifies the row of the
* CSV data, the second demension specifies the column. Each row starts with a
* label that details what digit the pixel data represents. Example of CSV
* header: label, pixel0, pixel1, pixel2, pixel 3, pixel4....
* Label data consists of an integer 0-9
* Pixel data consists of an integer 0-255 where 0 represents
* white and 255 represents black.
*****************************************************************************/
func getContentsOfCSV(fileName: String, hasLables: Bool) -> (rows: [[Int]], trainingRowLabels: [String]) {
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "csv")
    var rows: [[Int]] = []
    var trainingRowLabels = [String]()
    var startPosition = 0

    if (hasLables) {
        startPosition = 1
    }
    
    //get line of file and stick it into an array
    if let content = String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil) {
        var unSeparatedRowData = content.componentsSeparatedByString("\n")
        var limit = unSeparatedRowData.count - 1
        if (!hasLables) {
            limit = 30
        }
        
        
        //insert each pixel into an array and put that array into an array
        //        for row in unSeparatedRowData {
        for (var row = 1; row < limit; row++) {
            var newStringRow: [String] = []
            var newIntRow: [Int] = []
            newStringRow = unSeparatedRowData[row].componentsSeparatedByString(",")
            
            // Extract training labels
            if (hasLables) {
                trainingRowLabels.append(newStringRow[0])
            }
            
            //make sure the row has the content we want
            if newStringRow.count > 1 {
                for (var i = startPosition; i < newStringRow.count; i++){
                    let opNewInt = newStringRow[i].toInt()
                    if (opNewInt != nil) {
                        newIntRow.append(opNewInt!)
                    }
                }
                rows.append(newIntRow)
            }
        }
        println("Captured \(rows.count) rows from \(fileName).csv")
//        println("Row length for training: \(rows[1].count)")
        
    }
    return (rows, trainingRowLabels)
}