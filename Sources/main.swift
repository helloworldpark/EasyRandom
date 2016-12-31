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

let discreteRandom = ERDiscreteGeneratorBuilder<String>()
    .append(x: "a", p: 0.1)
    .append(x: "b", p: 0.2)
    .append(x: "c", p: 0.3)
    .append(x: "d", p: 0.4)
    .create()
let randomVariable = discreteRandom.generate(count: 1000)
for p in randomVariable {
    print("p \(p)")
}
