//
//  ERContinuous.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 31..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

typealias ContinuousVariable = Coord2D

public class ERContinuousMachine: RandomVariable {
    
    private let inverseCDF: SplineMachine
    
    init(from: Double, to: Double, partition p: Int, pdf f: (Double)->Double) {
        // Check negativeness of function
        precondition(p > 0, "Partitioning must be bigger than 0")
        precondition(ERMathHelper.isFunctionNegative(from: from, to: to, function: f) == false, "Probability Density function must be positive")
        
        // Find integral of the function for each partition
        let h = (to - from) / Double(p)
        var invCdf = [ContinuousVariable](repeating: ContinuousVariable(x:0.0, y:0.0), count: p+1)
        invCdf[0] = ContinuousVariable(x:0.0, y: from)
        for i in 1...p {
            let x1 = from + h * Double(i-1)
            let x2 = from + h * Double(i)
            let integral = ERMathHelper.integrate4(from: x1, to: x2, function: f)
            invCdf[i] = ContinuousVariable(x: integral + invCdf[i-1].x, y: x2)
        }
        let totalIntegral = invCdf.last!.x
        for i in 0...p {
            invCdf[i] = ContinuousVariable(x: invCdf[i].x/totalIntegral, y: invCdf[i].y)
            print("\(i) \(invCdf[i])")
        }
        
        // Construct Cumulative Distribution Function using Spline 
        self.inverseCDF = SplineMachine(data: invCdf)
    }
    
    func generate() -> Double {
        return self.inverseCDF.at(ERMathHelper.random())
    }
    
    func generate(count: Int) -> [Double] {
        var arr = [Double](repeating: 0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
    
    func showInverseCDF() {
        self.inverseCDF.graphOf()
    }
}
