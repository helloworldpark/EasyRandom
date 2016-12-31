//
//  ERMathHelper.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 28..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

public class ERMathHelper {
    fileprivate static let maxIteration = 10
    fileprivate static let eps = 1.0e-10

    public static func cubic(at x: Double, coefficent p: CubicPolynomial) -> Double {
        return p.d + x * (p.c + x * (p.b + x * p.a))
    }
    
    public static func norm(_ a: [Double], _ b: [Double]) -> Double {
        precondition(a.count == b.count && a.count > 0 && b.count > 0, "Mismatching vectors")
        var norm = 0.0
        for (x, y) in zip(a, b) {
            norm += (x - y) * (x - y)
        }
        return sqrt(norm)
    }
}

// MARK: Root Finding
extension ERMathHelper {
    // findRoot(y, a, b, f(t))->x
    // Find x s.t. y = f(x)
    // Expecting that f(x) is monotone function
    // Internally using bisection algorithm
    public static func root(find y: Double, from a: Double, to b:Double, function f: (Double)->Double)->Double {
        precondition(y < f(b) && f(a) < y, "y = \(y) must be between f(from) = \(f(a)) and f(to) = \(f(b))")
        var iteration = 0
        
        var x_a = a
        var x_b = b
        var x_mid = (x_a + x_b) * 0.5
        var y_mid = f(x_mid)
        
        while abs(y_mid - y) > ERMathHelper.eps || iteration < ERMathHelper.maxIteration {
            iteration += 1
            if y_mid < y {
                x_a = x_mid
            } else if y_mid > y {
                x_b = x_mid
            } else {
                break
            }
            x_mid = (x_a + x_b) * 0.5
            y_mid = f(x_mid)
        }
        return x_mid
    }
    
    public static func root(find y: Double, spline: Spline)->Double {
        precondition(y < spline.at(spline.to) && spline.at(spline.from) < y, "y = \(y) must be between f(from) = \(spline.at(spline.from)) and f(to) = \(spline.at(spline.to))")
        var iteration = 0
        
        var x_a = spline.from
        var x_b = spline.to
        var x_mid = (x_a + x_b) * 0.5
        var y_mid = ERMathHelper.cubic(at: x_mid, coefficent: spline.cubic)
        
        while abs(y_mid - y) > ERMathHelper.eps || iteration < ERMathHelper.maxIteration {
            iteration += 1
            if y_mid < y {
                x_a = x_mid
            } else if y_mid > y {
                x_b = x_mid
            } else {
                break
            }
            x_mid = (x_a + x_b) * 0.5
            y_mid = ERMathHelper.cubic(at: x_mid, coefficent: spline.cubic)
        }
        return x_mid
    }
}

// MARK: Spline Interpolation
extension ERMathHelper {
    // spline(from, to, partition, function)->[Spline]
    public static func spline(from: Double, to: Double, partition: Int, function f: (Double)->Double)->[Spline] {
        precondition(partition > 2, "Partition should be equal or more than 3 for spline interpolation")
        var data = [Coord2D](repeating: Coord2D(x: 0.0, y: 0.0), count: partition+1)
        let h = (to - from) / Double(partition)
        for i in 0...partition {
            let x = from + Double(i) * h
            data[i] = Coord2D(x: x, y: f(x))
        }
        return ERMathHelper.spline(data: data)
    }
    
    // spline(data: [Coord2D])->[Spline]
    public static func spline(data: [Coord2D])->[Spline] {
        // Assume that datas are N+1, 0 to N
        let N = data.count-1
        precondition(N > 2, "Data not enough for spline interpolation")
        
        // Prepare array of second derivatives
        // Set initial data: f''_0 = 0, f''_n+1 = 0
        var d2 = [Double](repeating: 0.0, count: N+1)
        
        // Prepare lhs and rhs of data
        var lhs = [[Double]](repeating: [Double](repeating: 0.0, count: 3), count: N+1)
        var rhs = [Double](repeating: 0.0, count: N+1)

        for i in 1...(N-1) {
            lhs[i][0] = (data[i].x - data[i-1].x) / (data[i+1].x - data[i-1].x)
            lhs[i][1] = 2.0
            lhs[i][2] = 1.0 - lhs[i][0]
            rhs[i] = (data[i+1].y - data[i].y) / (data[i+1].x - data[i].x) - (data[i].y - data[i-1].y) / (data[i].x - data[i-1].x)
            rhs[i] *= (6.0 / (data[i+1].x - data[i-1].x))
        }
        
        // Solve by Tridiagonal matrix algorithm
        // Process second column of lhs, then rhs
        lhs[1][2] /= lhs[1][1]
        rhs[1]    /= lhs[1][1]
        for i in 2..<(N-1) {
            lhs[i][2] /= (lhs[i][1] - lhs[i][0]*lhs[i-1][2])
            rhs[i]     = (rhs[i] - lhs[i][0]*rhs[i-1]) / (lhs[i][1] - lhs[i][0]*lhs[i-1][2])
        }
        rhs[N-1] = (rhs[N-1] - lhs[N-1][0]*rhs[N-2]) / (lhs[N-1][1] - lhs[N-1][0]*lhs[N-2][2])
        
        // Calculate cubic coefficients
        d2[N-1] = rhs[N-1]
        for i in (1...N-2).reversed() {
            d2[i] = rhs[i] - lhs[i][2]*d2[i+1]
        }
        
        // Return values
        var spline : [Spline] = []
        for i in 0..<N {
            let coef : CubicPolynomial = (a: d2[i+1], b: d2[i], c: data[i+1].y, d: data[i].y)
            spline.append(Spline(from: data[i].x, to: data[i+1].x, cubic: coef))
        }
        return spline
    }
}

// MARK: Integration
extension ERMathHelper {
    internal static let defaultPartition = 100
    
    private static let gauss2 = [-0.5773502691896257: 1.0,
                                 0.5773502691896257: 1.0]
    
    private static let gauss3 = [-0.7745966692414834: 0.5555555555555555,
                                 0.0: 0.8888888888888888,
                                 0.7745966692414834: 0.5555555555555555]
    
    private static let gauss4 = [-0.8611363115940526: 0.3478548451374539,
                                 -0.3399810435848563: 0.6521451548625461,
                                 0.3399810435848563: 0.6521451548625461,
                                 0.8611363115940526: 0.3478548451374539]
    // integrate(from, to, function) -> Double
    // Definite Integral of f(x) from a to b
    // Internally using Repeated Gaussian Quadrature of n = 2
    
    public static func integrate(from a: Double, to b: Double, partition n: Int = ERMathHelper.defaultPartition, function f: (Double)->Double)->Double {
        return ERMathHelper.integrate2(from: a, to: b, partition: n, function: f)
    }
    
    public static func integrate2(from a: Double, to b: Double, partition n: Int = ERMathHelper.defaultPartition, function f: (Double)->Double)->Double {
        var result = 0.0
        let h = (b-a)/Double(n)
        let cc = h*0.5
        for i in 0..<n {
            let aa = a+h*Double(i)
            for coef in ERMathHelper.gauss2 {
                result += coef.value * f(aa + cc * (coef.key + 1.0))
            }
        }
        return cc * result
    }
    
    public static func integrate3(from a: Double, to b: Double, partition n: Int = ERMathHelper.defaultPartition, function f: (Double)->Double)->Double {
        var result = 0.0
        let h = (b-a)/Double(n)
        let cc = h*0.5
        for i in 0..<n {
            let aa = a+h*Double(i)
            for coef in ERMathHelper.gauss3 {
                result += coef.value * f(aa + cc * (coef.key + 1.0))
            }
        }
        return cc * result
    }
    
    public static func integrate4(from a: Double, to b: Double, partition n: Int = ERMathHelper.defaultPartition, function f: (Double)->Double)->Double {
        var result = 0.0
        let h = (b-a)/Double(n)
        let cc = h*0.5
        for i in 0..<n {
            let aa = a+h*Double(i)
            for coef in ERMathHelper.gauss4 {
                result += coef.value * f(aa + cc * (coef.key + 1.0))
            }
        }
        return cc * result
    }
}
