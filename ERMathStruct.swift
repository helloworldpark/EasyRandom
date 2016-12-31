//
//  ERMathStruct.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 30..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

public typealias CubicPolynomial = (a: Double, b: Double, c:Double, d: Double)

public struct Coord2D: Equatable, RangeSearchable {
    let x: Double
    let y: Double
    
    var searchby: Double {
        get {
            return y
        }
    }
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public static func ==(lhs: Coord2D, rhs: Coord2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public struct Spline: Equatable, Comparable, RangeSearchable {
    private let dx: Double
    let from: Double
    let to: Double
    let cubic: CubicPolynomial
    
    var searchby: Double {
        get {
            return self.from
        }
    }
    
    init(from: Double, to: Double, cubic: CubicPolynomial) {
        self.from = from
        self.to = to
        self.dx = to - from
        self.cubic = cubic
    }
    
    public static func ==(lhs: Spline, rhs: Spline)->Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
    
    public static func <(lhs: Spline, rhs: Spline)->Bool {
        return lhs.from < rhs.from
    }
    
    public static func <=(lhs: Spline, rhs: Spline)->Bool {
        return lhs.from <= rhs.from
    }
    
    public static func >(lhs: Spline, rhs: Spline)->Bool {
        return lhs.from > rhs.from
    }
    
    public static func >=(lhs: Spline, rhs: Spline)->Bool {
        return lhs.from >= rhs.from
    }
    
    public func at(x: Double) -> Double {
        let u = (self.to - x) / self.dx
        let v = 1.0 - u
        let dxdx = self.dx*self.dx/6.0
//        print("u = \(u) v = \(v)")
        return dxdx*(v*(v*v - 1.0) * self.cubic.a + u*(u*u - 1.0) * self.cubic.b) +  v * self.cubic.c + u * self.cubic.d
    }
}

public struct SplineMachine {
    private let spline: [Spline]
    
    init(data: [Coord2D]) {
        var spline = ERMathHelper.spline(data: data)
        spline.sort()
        self.spline = spline
    }
    
    init(from: Double, to: Double, partition: Int, function: (Double)->Double) {
        var spline = ERMathHelper.spline(from: from, to: to, partition: partition, function: function)
        spline.sort()
        self.spline = spline
    }
    
    public func at(x: Double) -> Double {
        guard let indexRange = spline.rangeSearch(with: x) else {
            if x < spline.first!.from {
                return spline.first!.at(x: x)
            } else {
                return spline[spline.count-1].at(x: x)
            }
        }
        return spline[indexRange.from].at(x: x)
    }
    
    public func printSpline() {
        print("SplineMachine")
        for splines in spline {
            print("from \(splines.from) to \(splines.to) a \(splines.cubic.a) b \(splines.cubic.b) c \(splines.cubic.c) d \(splines.cubic.d)")
        }
    }
}
