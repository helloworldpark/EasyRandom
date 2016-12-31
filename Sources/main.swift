//
//  main.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 28..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

print("Hello, World!")

testNorm()
testRoot()
testIntegral()
testSplinePoint()

let histogram = [Coord2D(x: 1.0, y: 0.1), Coord2D(x: 2.0, y: -0.2), Coord2D(x: 3.0, y: 0.3), Coord2D(x: 4.0, y: 0.4)]
let discreteRandom = ERDiscrete(histogram: histogram)
let randomVariable = discreteRandom.generate(count: 1000)
for p in randomVariable {
    print("p \(Int(p))")
}
