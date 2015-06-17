//
//  Knn.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 6/13/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation

class Recognizer {
    
    /*****************************************************************
    * EUCLIDEAN DISTANCE
    *****************************************************************/
    func euclideanDistance(a: [Int], b: [Int]) -> Double{
        var distance: Double = 0
        for (var componentIndex = 0; componentIndex < a.count; componentIndex++) {
            let delta = b[componentIndex] - a[componentIndex]
            distance += Double(delta * delta)
        }
        distance = sqrt(distance)
        return distance
    }
    
    /*****************************************************************
    * FIND NEAREST NEIGHBOR LABLES
    *****************************************************************/
    func findNearestNeighborLabels(k: Int, trainingRows: [[Int]], testRow: [Int]) -> [Int]{
        var nearestNeighborLabels = [Int]()
        var nearestNeighbors = [Int: Double]()
        
        for (var trainingRowIndex = 0; trainingRowIndex < trainingRows.count; trainingRowIndex++) {
            // Get the euclidean distance
            let distance = euclideanDistance(trainingRows[trainingRowIndex], b: testRow)
            var count = nearestNeighbors.count
//            if (nearestNeighbors.count == 0 || distance < Array(nearestNeighbors.values)[nearestNeighbors.count - 1]) {
//                nearestNeighbors[trainingRowLabes[trainingRowIndex]] = distance
//            }
            
            
            
        }
        
        return nearestNeighborLabels
    }
    
    /*****************************************************************
    * MODE
    *****************************************************************/
    func mode() {
        
    }
    
    /*****************************************************************
    * KNN
    *****************************************************************/
    func knn(k: Int, trainingRows: [[Int]], testRows: [[Int]]) {
        var testRowLabels = [Int]()
        var trainingRowLabels = [Int]()
        
        for (var testRowIndex = 0; testRowIndex < testRows.count; testRowIndex++) {
            var nearestNeighborLabels = findNearestNeighborLabels(k, trainingRows: trainingRows, testRow: testRows[testRowIndex])
//            var modeNearestNeighborLabel = mode()
            
            // Set labels
//            testRowLabels.append(modeNearestNeighborLabel)
            
            // DEBUG print labels
            
        }
    }
}