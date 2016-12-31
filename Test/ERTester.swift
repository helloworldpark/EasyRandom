//
//  ERTester.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 30..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

func report(expect: Double, actual: Double, title: String, error: Double = 1.0e-10) -> Bool {
    print("Test \(title)")
    let err = abs(expect - actual)
    if err < error {
        print("*******Test success: expected \(expect) actual \(actual) error \(err)")
        return true
    } else {
        print("!!!!!!!Test failed: expected \(expect) actual \(actual) error \(err)")
        return false
    }
}

func reportBool(expect: Bool, actual: Bool, title: String) -> Bool {
    if expect == actual {
        print("*******Test success: expected \(expect) actual \(actual)")
        return true
    } else {
        print("!!!!!!!Test failed: expected \(expect) actual \(actual)")
        return false
    }
}

func reportVector(compare: [Double], with: [Double], title: String, error: Double = 1.0e-10) -> Bool {
    print("Test \(title)")
    let err = ERMathHelper.norm(compare, with)/Double(compare.count)
    if err < error {
        print("*******Test success: error is \(err)")
        return true
    } else {
        print("!!!!!!!Test failed: error is \(err)")
        return false
    }
}

func rootTester(find: Double, from: Double, to: Double, expect: Double, function: (Double)->Double) {
    _ = report(expect: expect, actual: ERMathHelper.root(find: find, from: from, to: to, function: function), title: "Find Root")
}

func integralTester(from: Double, to: Double, partition: Int, expect: Double, function: (Double)->Double) {
    _ = report(expect: expect, actual: ERMathHelper.integrate4(from: from, to: to, partition: partition, function: function), title: "Integral")
}

func splineDataTester(data: [Coord2D]) {
    let spline = ERMathHelper.spline(data: data)
    var compare: [Coord2D] = []
    for i in 0..<data.count-1 {
        compare.append(Coord2D(x: data[i].x, y: spline[i].at(data[i].x)))
    }
    compare.append(Coord2D(x: data[data.count-1].x, y: spline[data.count-2].at(data[data.count-1].x)))
    let yData = data.map { $0.y }
    let yCompare = compare.map { $0.y }
    _ = reportVector(compare: yData, with: yCompare, title: "Spline at data")
}

func splineFuncTester(from: Double, to: Double, partition: Int, function f: (Double)->Double) {
    let subpart = 10
    let MAXPART = 100
    let splineMachine = SplineMachine(from: from, to: to, partition: partition, function: f)
    
    var data: [Coord2D] = []
    var compare: [Coord2D] = []
    let totalPart = max(subpart * partition, MAXPART)
    let h = (to - from)/Double(totalPart)
    for i in 0..<totalPart {
        let x = from + Double(i)*h
        data.append(Coord2D(x: x, y: f(x)))
        compare.append(Coord2D(x: x, y: splineMachine.at(x)))
    }
    let yData = data.map { $0.y }
    let yCompare = compare.map { $0.y }
    _ = reportVector(compare: yData, with: yCompare, title: "Spline at function")
}

func testNorm() {
    let v = [0.0, 1.0, 2.0, 3.0]
    let w = [3.0, 2.0, 1.0, 0.0]
    _ = report(expect: sqrt(20.0), actual: ERMathHelper.norm(v, w), title: "Norm")
}

func testRoot() {
    let quad: (Double)->Double = { (t: Double) in
        return t*t
    }
    rootTester(find: 0.5, from: 0.0, to: 1.0, expect: sqrt(0.5), function: quad)
    rootTester(find: 0.5, from: 0.0, to: M_PI_2, expect: asin(0.5), function: sin)
}

func testIntegral() {
    let cub: (Double)->Double = { (t: Double) in
        return 2.0 * t*t*t - 3.0 * t*t + 1.0 * t + 1.0
    }
    let realCub = 0.5 * (2.0 * 2.0 * 2.0 * 2.0) - 2.0 * 2.0 * 2.0 + 0.5 * 2.0 * 2.0 + 2.0
    integralTester(from: 0.0, to: 2.0, partition: 1, expect: realCub, function: cub)
    integralTester(from: 0.0, to: M_PI, partition: 10, expect: 2.0, function: sin)
    integralTester(from: 0.0, to: M_PI, partition: 20, expect: 2.0, function: sin)
    integralTester(from: 0.0, to: M_PI, partition: 30, expect: 2.0, function: sin)
    integralTester(from: 0.0, to: M_PI*2.5, partition: 3, expect: 1.0, function: cos)
}

func testSplinePoint() {
    var coordspline: [Coord2D] = []
    coordspline.append(Coord2D(x: 0.0, y: sin(0.0)))
    coordspline.append(Coord2D(x: 0.5, y: sin(0.5)))
    coordspline.append(Coord2D(x: 1.0, y: sin(1.0)))
    coordspline.append(Coord2D(x: 1.5, y: sin(1.5)))
    coordspline.append(Coord2D(x: 2.0, y: sin(2.0)))
    coordspline.append(Coord2D(x: 2.5, y: sin(2.5)))
    coordspline.append(Coord2D(x: 3.0, y: sin(3.0)))
    coordspline.append(Coord2D(x: 3.5, y: sin(3.5)))
    coordspline.append(Coord2D(x: 4.0, y: sin(4.0)))
    
    splineDataTester(data: coordspline)
    splineFuncTester(from: 0.0, to: M_PI * 2.5, partition: 100, function: cos)
}

func testIsFunctionNegative() {
    _ = reportBool(expect: true, actual: ERMathHelper.isFunctionNegative(from: 0.0, to: 2.0*M_PI, function: sin), title: "Sine Negative")
}


