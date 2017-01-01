//
//  ERSpline.swift
//  EasyRandom
//
//  Created by LinePlus on 2017. 1. 1..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import Foundation

public struct Spline: Equatable, Comparable, RangeSearchable {
    private let dx: Double
    private let dxdx: Double
    let from: Double
    let to: Double
    let cubic: CubicPolynomial
    
    var keyword: Double {
        return self.from
    }
    
    init(from: Double, to: Double, cubic: CubicPolynomial) {
        self.from = from
        self.to = to
        self.dx = to - from
        self.dxdx = self.dx*self.dx/6.0
        self.cubic = cubic
    }
    
    public func at(_ x: Double) -> Double {
        let u = (self.to - x) / self.dx
        let v = 1.0 - u
        return self.dxdx*(v*(v*v - 1.0) * self.cubic.a + u*(u*u - 1.0) * self.cubic.b) +  v * self.cubic.c + u * self.cubic.d
    }
    
    public func isMonotoneIncreasing() -> Bool {
        let d_ba = self.cubic.b - self.cubic.a
        if abs(d_ba) < 1.0e-5 {
            return self.cubic.c > self.cubic.d
        }
        let minx = self.cubic.b / d_ba
        if minx < 0.0 {
            return d_ba < 0.0
        }
        if minx > 1.0 {
            return d_ba > 0.0
        }
        let miny = self.dxdx * (d_ba + 3.0 * self.cubic.a * minx) + self.cubic.c - self.cubic.d
        return miny >= 0.0
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
}

public struct SplineMachine {
    private let spline: [Spline]
    public let norm: Double
    
    init(data: [Coord2D]) {
        var spline = ERMathHelper.spline(data: data)
        spline.sort()
        var norm = spline.first!.to - spline.first!.from
        for piece in spline {
            let pieceNorm = (piece.to - piece.from)
            if norm < pieceNorm {
                norm = pieceNorm
            }
        }
        self.norm = norm
        self.spline = spline
    }
    
    init(from: Double, to: Double, partition: Int, function: (Double)->Double) {
        var spline = ERMathHelper.spline(from: from, to: to, partition: partition, function: function)
        spline.sort()
        var norm = spline.first!.to - spline.first!.from
        for piece in spline {
            let pieceNorm = (piece.to - piece.from)
            if norm < pieceNorm {
                norm = pieceNorm
            }
        }
        self.norm = norm
        self.spline = spline
    }
    
    public func at(_ x: Double) -> Double {
        guard let indexRange = spline.rangeSearch(with: x) else {
            if x < spline.first!.from {
                return spline.first!.at(x)
            } else {
                return spline.last!.at(x)
            }
        }
        return spline[indexRange.from].at(x)
    }
    
    public func isMonotoneIncreasing() -> Bool {
        for piece in spline {
            if piece.isMonotoneIncreasing() == false {
                return false
            }
        }
        return true
    }
    
    public func printGraph() {
        let from = spline.first!.from
        let to = spline.last!.to
        let h = (to - from)/1000.0
        for i in 0...1000 {
            let x = from + h * Double(i)
            print("\(x) \(self.at(x))")
        }
    }
}
