//
//  ERContinuous.swift
//  EasyRandom
//
//  Created by Helloworld Park on 2016. 12. 31..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

open class ERContinuousPDF: RandomVariable {
    static let maximumNorm = 1.0e-2
    let inverseCDF: SplineMachine
    
    public init(from: Double, to: Double, partition p: Int, pdf f: (Double)->Double) {
        precondition(to > from, "'to(\(to))' must be bigger than 'from\(from)'")
        // Check negativeness of function
        precondition(p > 0, "Partitioning must be bigger than 0")
        precondition(ERMathHelper.isFunctionNegative(from: from, to: to, function: f) == false, "Probability Density function must be positive")
        
        var p_new = p
        var candidateCDF = ERContinuousPDF.inverseCDF(from: from, to: to, partition: p_new, pdf: f)
        while candidateCDF.norm > ERContinuousPDF.maximumNorm {
            p_new *= 2
            candidateCDF = ERContinuousPDF.inverseCDF(from: from, to: to, partition: p_new, pdf: f)
        }
        self.inverseCDF = candidateCDF
    }
    
    open func generate() -> Double {
        return self.inverseCDF.at(ERMathHelper.random())
    }
    
    open func generate(count: Int) -> [Double] {
        var arr = [Double](repeating: 0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
    
    func showInverseCDF() {
        self.inverseCDF.printGraph()
    }
    
    private static func inverseCDF(from: Double, to: Double, partition p: Int, pdf f: (Double)->Double) -> SplineMachine {
        // Find integral of the function for each partition
        let h = (to - from) / Double(p)
        var invCdf = [Coord2D](repeating: Coord2D(x:0.0, y:0.0), count: p+1)
        invCdf[0] = Coord2D(x:0.0, y: from)
        for i in 1...p {
            let x1 = from + h * Double(i-1)
            let x2 = from + h * Double(i)
            let integral = ERMathHelper.integrate4(from: x1, to: x2, function: f)
            invCdf[i] = Coord2D(x: integral + invCdf[i-1].x, y: x2)
        }
        let totalIntegral = invCdf.last!.x
        for i in 0...p {
            invCdf[i] = Coord2D(x: invCdf[i].x/totalIntegral, y: invCdf[i].y)
        }
        return SplineMachine(data: invCdf)
    }
}

open class ERContinuousCDF: RandomVariable {
    let cdf : (Double)->Double
    let from: Double
    let to: Double
    
    public init(from: Double, to: Double, cdf: @escaping (Double)->Double) {
        precondition(to > from, "'to(\(to))' must be bigger than 'from\(from)'")
        precondition(ERMathHelper.isMonotoneIncreasing(from: from, to: to, function: cdf), "Cumulative Distribution Function must be monotone increasing")
        self.from = from
        self.to = to
        self.cdf = cdf
    }
    
    open func generate() -> Double {
        let p = ERMathHelper.random()
        return ERMathHelper.root(find: p, from: from, to: to, function: self.cdf)
    }
    
    open func generate(count: Int) -> [Double] {
        var arr = [Double](repeating: 0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
}

open class ERContinuousInvCDF: RandomVariable {
    let invcdf : (Double)->Double
    let from: Double
    let to: Double
    
    public init(from: Double, to: Double, invcdf: @escaping (Double)->Double) {
        precondition(to > from, "'to(\(to))' must be bigger than 'from\(from)'")
        precondition(ERMathHelper.isMonotoneIncreasing(from: from, to: to, function: invcdf), "Inverse Cumulative Distribution Function must be monotone increasing")
        self.from = from
        self.to = to
        self.invcdf = invcdf
    }
    
    open func generate() -> Double {
        return self.invcdf(ERMathHelper.random())
    }
    
    open func generate(count: Int) -> [Double] {
        var arr = [Double](repeating: 0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
}
