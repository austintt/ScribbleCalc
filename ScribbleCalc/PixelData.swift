//
//  PixelData.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 6/1/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import Foundation
public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8

    init (value: Int) {
        self.a = 255
        self.r = UInt8(value)
        self.g = UInt8(value)
        self.b = UInt8(value)
    }
}

