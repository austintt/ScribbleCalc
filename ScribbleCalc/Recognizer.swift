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
    * NEW EUCLIDDEAN DISTANCE
    *****************************************************************/
    func eucliddeanDistance(a: [Int], b: [Int]) -> Double {
        var distance: Double = 0
        
        for (var i = 0; i < a.count; i++) {
            var delta = Double(b[i] - a[i])
            distance += delta * delta
        }
        distance = sqrt(distance)
        
        return distance
    }
    
    
    /*****************************************************************
    * NEW FIND NEAREST NEIGHBOR LABLES
    *****************************************************************/
    func findNearestNeighborLables(k: Int, trainingRows: [[Int]], trainingRowLables: [String], testRow: [Int]) -> [String]{
        var nearestNeighborLabels = [String]()
        var nearestNeighbors: [(key: String, value: Double)] = []
        println("Finding NN Lables")
        
        assert(trainingRows.count > 0)
        for (var i = 0; i < trainingRows.count; i++) {
            let distance = eucliddeanDistance(trainingRows[i], b: testRow)
            assert(distance > 0)
            if (nearestNeighbors.count == 0 || distance < nearestNeighbors.last!.value) {
                nearestNeighbors.append(key: trainingRowLables[i], value: distance)
                if (nearestNeighbors.count > k) {
                    println("PRE-SORTED")
                    for n in nearestNeighbors {
                        println(n)
                    }
                    nearestNeighbors = sorted(nearestNeighbors) {a,b in return a.value <= b.value}
                    nearestNeighbors.removeAtIndex(nearestNeighbors.count - 1)
                    println("SORTED")
                    for n in nearestNeighbors {
                        println(n)
                    }
                }
            }
            
        }
        
        // Extract the lables
        for (var i = 0; i < nearestNeighbors.count; i++) {
            nearestNeighborLabels.append(nearestNeighbors[i].key)
        }
        println("Found \(nearestNeighborLabels.count) nn lables")
        return nearestNeighborLabels
    }
    
    /*****************************************************************
    * MODE
    *****************************************************************/
    func mode(lables: [String]) -> String {
        var finalLabel = ""
        var nearestNeighborsLabelsHistogram = [Int:Int]()
        assert(lables.count > 0)
        for (var i = 0; i < lables.count; i++) {
            if (nearestNeighborsLabelsHistogram.indexForKey(lables[i].hashValue) == nil) {
                nearestNeighborsLabelsHistogram[lables[i].hashValue] = 1
            }
            else {
                nearestNeighborsLabelsHistogram[lables[i].hashValue]!++
            }
        }
        var nearestNeighborsLabelsHistogramSorted = sorted(nearestNeighborsLabelsHistogram) {a,b in return a.1 >= b.1}
        var labelsMode = nearestNeighborsLabelsHistogramSorted[0].0
//        if (labelsMode == 4799450059485597605) {
//            finalLabel = "+"
//        }
//        else {
//            finalLabel = "\(labelsMode)"
//        }
        switch labelsMode {
        case 4799450059485597605:
            finalLabel = "+"
        case 4799450059485597618:
            finalLabel = "0"
        case 4799450059485597623:
            finalLabel = "1"
        case 4799450059485597624:
            finalLabel = "2"
        case 4799450059485597629:
            finalLabel = "3"
        case 4799450059485597630:
            finalLabel = "4"
        case 4799450059485597571:
            finalLabel = "5"
        case 4799450059485597572:
            finalLabel = "6"
        case 4799450059485597577:
            finalLabel = "7"
        case 4799450059485597578:
            finalLabel = "8"
        case 4799450059485597583:
            finalLabel = "9"
        default:
            finalLabel = "!"

        }
        println("MODE: \(finalLabel)")
        return finalLabel
    }
    
    /*****************************************************************
    * KNN
    *****************************************************************/
    func knn(k: Int, trainingRows: [[Int]], trainingRowLables: [String], testRows: [[Int]]) -> [String]{
        var testLables = [String]()
        
        for testRow in testRows {
            // Get NN Lables
            var nnLables = findNearestNeighborLables(k, trainingRows: trainingRows, trainingRowLables: trainingRowLables, testRow: testRow)
            // Get mode
            var modeNNLable = mode(nnLables)
            testLables.append(modeNNLable)
        }

        return testLables
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    /*****************************************************************
//    * EUCLIDEAN DISTANCE
//    *****************************************************************/
//    func euclideanDistance(a: [Int], b: [Int]) -> Double{
//        var distance: Double = 0
//        for (var componentIndex = 0; componentIndex < a.count; componentIndex++) {
//            let delta = Double(b[componentIndex] - a[componentIndex])
//            distance += delta * delta
//        }
//        distance = sqrt(distance)
//        return distance
//    }
//    
//    /*****************************************************************
//    * FIND NEAREST NEIGHBOR LABLES
//    *****************************************************************/
//    func findNearestNeighborLabels(k: Int, trainingRows: [[Int]], trainingRowLables: [Int], testRow: [Int]) -> [Int]{
//        var nearestNeighborLabels: [Int] = []
//        var nearestNeighbors = [Int, Double]()
//        var sortedNeighbors = [Int,Double]()
//        
//        for (var trainingRowIndex = 0; trainingRowIndex < trainingRows.count; trainingRowIndex++) {
//            // Get the euclidean distance
//            let distance = euclideanDistance(trainingRows[trainingRowIndex], b: testRow)
//            var count = nearestNeighbors.count
////            if (nearestNeighbors.count == 0 || distance < nearestNeighbors[nearestNeighbors.count - 1].1) {
//                //                nearestNeighbors[trainingRowLables[trainingRowIndex]] = distance
//                nearestNeighbors.append(trainingRowLables[trainingRowIndex], distance)
//                if (nearestNeighbors.count > k) {
//                    //                    nearestNeighbors = sorted(nearestNeighbors) {a,b in return a.1 >= b.1}
//                    sortedNeighbors = sorted(nearestNeighbors) {a,b in return a.1 >= b.1}
//                    sortedNeighbors.removeAtIndex(sortedNeighbors.count - 1)
//                }
//            //}
//        }
//        
//        // Get the labels
//        for (var nearestNeighborsIndex = 0; nearestNeighborsIndex < sortedNeighbors.count; nearestNeighborsIndex++) {
//            //            nearestNeighborLabels.insert(sortedNeighbors[nearestNeighborsIndex].0, atIndex: nearestNeighborsIndex)
//            nearestNeighborLabels.append(sortedNeighbors[nearestNeighborsIndex].0)
//            println("Guesses: ")
//            for guess in sortedNeighbors {
//                println(guess)
//            }
//        }
//        
//        return nearestNeighborLabels
//    }
//    
//    /*****************************************************************
//    * MODE
//    *****************************************************************/
//    func mode(nearestNeighborLabels: [Int]) -> Int {
//        var nearestNeighborsLabelsHistogram = [Int:Int]()
//        assert(nearestNeighborLabels.count > 0)
//        for (var nearestNeighborsLabelsIdx = 0; nearestNeighborsLabelsIdx < nearestNeighborLabels.count; nearestNeighborsLabelsIdx++) {
//            if (nearestNeighborsLabelsHistogram.indexForKey(nearestNeighborLabels[nearestNeighborsLabelsIdx]) == nil) {
//                nearestNeighborsLabelsHistogram[nearestNeighborLabels[nearestNeighborsLabelsIdx]] = 1
//            }
//            else {
//                nearestNeighborsLabelsHistogram[nearestNeighborLabels[nearestNeighborsLabelsIdx]]!++
//            }
//        }
//        var nearestNeighborsLabelsHistogramSorted = sorted(nearestNeighborsLabelsHistogram) {a,b in return a.1 >= b.1}
//        return nearestNeighborsLabelsHistogramSorted[0].0
//    }
//    
//    /*****************************************************************
//    * KNN
//    *****************************************************************/
//    func knn(k: Int, trainingRows: [[Int]], trainingRowLables: [Int], testRows: [[Int]]) -> [Int]{
//        var testRowLabels = [Int]()
//        
//        for (var testRowIndex = 0; testRowIndex < testRows.count; testRowIndex++) {
//            var nearestNeighborLabels = findNearestNeighborLabels(k, trainingRows: trainingRows, trainingRowLables: trainingRowLables, testRow: testRows[testRowIndex])
//            var modeNearestNeighborLabel = mode(nearestNeighborLabels)
//            
//            // Set labels
//            testRowLabels.append(modeNearestNeighborLabel)
//            
//        }
//        // DEBUG print labels
//        for label in testRowLabels {
//            println("Label Guess: \(label)")
//        }
//        
//        return testRowLabels
//    }
}