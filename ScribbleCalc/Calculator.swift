//
//  Calculator.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 6/29/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation

class Calculator {
    
    func labelParser(labels: [String]) -> [String]{
        var newNumber = ""
        var components = [String]()
        
        for (var i = 0; i < labels.count; i++) {
            // Concatonate individual numbers
            if (labels[i] != "+" && labels[i] != "-") {
                newNumber += labels[i]
            }
                // Seperate at symbols and refresh
            else if (labels[i] == "+" || labels[i] == "-"){
                components.append(newNumber)
                newNumber = ""
                components.append(labels[i])
            }
        }
        components.append(newNumber)
        return components
    }
    
    
    func solve(inputLabels: [String]) -> Int{
        var result: Int = 0
        
        
        // Parse
        var parsedLabels = labelParser(inputLabels)
        
        // Convert Ints
        var numbers = [Int]()
        var symbols = [String]()
        for (var i = 0; i < parsedLabels.count; i++) {
            if (parsedLabels[i] != "+" && parsedLabels[i] != "-") {
                numbers.append(parsedLabels[i].toInt()!)
            }
            else {
                symbols.append(parsedLabels[i])
            }
            println(numbers)
            println(symbols)
        }
        
        // Solve
        assert(symbols.count > 0)
        if (symbols.count > 0) {
            if (symbols.first == "+") {
                if numbers.count > 1 {
                    result = numbers[0] + numbers[1]
                }
            }
            else if (symbols.first == "-") {
                if numbers.count > 1 {
                    result = numbers[0] - numbers[1]
                }
            }
            else {
                println("ERROR IN CALCULATION")
            }
        }
        
        return result
    }
}