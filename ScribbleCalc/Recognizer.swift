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
            let delta = Double(b[componentIndex] - a[componentIndex])
            distance += delta * delta
        }
        distance = sqrt(distance)
        return distance
    }
    
    /*****************************************************************
    * FIND NEAREST NEIGHBOR LABLES
    *****************************************************************/
    func findNearestNeighborLabels(k: Int, trainingRows: [[Int]], trainingRowLables: [Int], testRow: [Int]) -> [Int]{
        var nearestNeighborLabels: [Int] = []
        var nearestNeighbors = [Int, Double]()
        var sortedNeighbors = [Int,Double]()
        
        for (var trainingRowIndex = 0; trainingRowIndex < trainingRows.count; trainingRowIndex++) {
            // Get the euclidean distance
            let distance = euclideanDistance(trainingRows[trainingRowIndex], b: testRow)
            var count = nearestNeighbors.count
            if (nearestNeighbors.count == 0 || distance < nearestNeighbors[nearestNeighbors.count - 1].1) {
                //                nearestNeighbors[trainingRowLables[trainingRowIndex]] = distance
                nearestNeighbors.append(trainingRowLables[trainingRowIndex], distance)
                if (nearestNeighbors.count > k) {
                    //                    nearestNeighbors = sorted(nearestNeighbors) {a,b in return a.1 >= b.1}
                    sortedNeighbors = sorted(nearestNeighbors) {a,b in return a.1 >= b.1}
                    sortedNeighbors.removeAtIndex(sortedNeighbors.count - 1)
                }
            }
        }
        
        // Get the labels
        for (var nearestNeighborsIndex = 0; nearestNeighborsIndex < sortedNeighbors.count; nearestNeighborsIndex++) {
            //            nearestNeighborLabels.insert(sortedNeighbors[nearestNeighborsIndex].0, atIndex: nearestNeighborsIndex)
            nearestNeighborLabels.append(sortedNeighbors[nearestNeighborsIndex].0)
            println("Guesses: ")
            for guess in sortedNeighbors {
                println(guess)
            }
        }
        
        return nearestNeighborLabels
    }
    
    /*****************************************************************
    * MODE
    *****************************************************************/
    func mode(nearestNeighborLabels: [Int]) -> Int {
        var nearestNeighborsLabelsHistogram = [Int:Int]()
        for (var nearestNeighborsLabelsIdx = 0; nearestNeighborsLabelsIdx < nearestNeighborLabels.count; nearestNeighborsLabelsIdx++) {
            if (nearestNeighborsLabelsHistogram.indexForKey(nearestNeighborLabels[nearestNeighborsLabelsIdx]) == nil) {
                nearestNeighborsLabelsHistogram[nearestNeighborLabels[nearestNeighborsLabelsIdx]] = 1
            }
            else {
                nearestNeighborsLabelsHistogram[nearestNeighborLabels[nearestNeighborsLabelsIdx]]!++
            }
        }
        var nearestNeighborsLabelsHistogramSorted = sorted(nearestNeighborsLabelsHistogram) {a,b in return -a.1 >= b.1}
        return nearestNeighborsLabelsHistogramSorted[0].0
    }
    
    /*****************************************************************
    * KNN
    *****************************************************************/
    func knn(k: Int, trainingRows: [[Int]], trainingRowLables: [Int], testRows: [[Int]]) -> [Int]{
        var testRowLabels = [Int]()
        
        for (var testRowIndex = 0; testRowIndex < testRows.count; testRowIndex++) {
            var nearestNeighborLabels = findNearestNeighborLabels(k, trainingRows: trainingRows, trainingRowLables: trainingRowLables, testRow: testRows[testRowIndex])
            var modeNearestNeighborLabel = mode(nearestNeighborLabels)
            
            // Set labels
            testRowLabels.append(modeNearestNeighborLabel)
            
        }
        // DEBUG print labels
        for label in testRowLabels {
            println("Label Guess: \(label)")
        }
        
        return testRowLabels
    }
}