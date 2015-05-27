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
func getContentsOfCSV(fileName: String) -> [[String]] {
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "csv")
    var rows: [[String]] = []
    
    //get line of file and stick it into an array
    if let content = String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil) {
        var unSeparatedRowData = content.componentsSeparatedByString("\n")
        
        //insert each pixel into an array and put that array into an array
        for row in unSeparatedRowData {
            var newRow: [String] = []
            newRow = row.componentsSeparatedByString(",")
            
            //make sure the row has the content we want
            if newRow.count > 1 {
                rows.append(newRow)
            }
        }
        println("Captured \(rows.count) rows from \(fileName).csv")
    }
    return rows
}