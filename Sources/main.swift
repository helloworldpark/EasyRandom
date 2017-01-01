//
//  main.swift
//  EasyRandom
//
//  Created by Helloworld Park on 2016. 12. 28..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

print("Hello, World!")

testNorm()
testRoot()
testIntegral()
testSplinePoint()
testIsFunctionNegative()

//let discreteRandom = ERDiscreteGeneratorBuilder<String>()
//    .append(x: "a", p: 0.1)
//    .append(x: "b", p: 0.2)
//    .append(x: "c", p: 0.3)
//    .append(x: "d", p: 0.4)
//    .create()
//let randomVariable = discreteRandom.generate(count: 1000)
//for p in randomVariable {
//    print("p \(p)")
//}

let pdf = ERContinuousFactory(from: 0.0, to: 1.0).pdf { 6.0 * $0 * (1.0 - $0) }
let rvs = pdf.generate(count: 10000)
for p in rvs {
    print("\(p)")
}


