//
//  ERDiscrete.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 29..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

public class ERDiscrete<T> : RandomVariable {
    private let discreteMachine: ERDiscreteCalculator
    private let variable: [T]
    
    public init(x: [T], probability: [Double]) {
        precondition(x.count == probability.count, "Size of X and Probability arrays do not match.")
        self.variable = x
        var histogram = [IntCoord2D]()
        for i in 0..<probability.count {
            histogram.append(IntCoord2D(x: i, y: probability[i]))
        }
        self.discreteMachine = ERDiscreteCalculator(histogram: histogram)
    }
    
    open func generate() -> T {
        return self.variable[discreteMachine.generate()]
    }
    
    open func generate(count: Int) -> [T] {
        return self.discreteMachine.generate(count: count).map { self.variable[$0] }
    }
}

open class ERDiscreteCalculator : RandomVariable {
    let cumulated: [IntCoord2D]
    
    public init(histogram: [IntCoord2D]) {
        precondition(histogram.count != 0, "Empty Histogram!")
        let sum = histogram.reduce(0.0) { result, coord in result + (coord.y >= 0.0 ? coord.y: 0.0) }
        var cumulative = [IntCoord2D](repeating: IntCoord2D(x: 0, y: 0.0), count: histogram.count+1)
        var cumsum = 0.0
        for i in 0..<histogram.count {
            cumulative[i] = IntCoord2D(x: histogram[i].x, y: cumsum / sum)
            cumsum += (histogram[i].y >= 0.0 ? histogram[i].y : 0.0)
        }
        // Dummy
        cumulative[cumulative.count-1] = IntCoord2D(x: histogram.last!.x + 1, y: 1.0)
        self.cumulated = cumulative
    }
    
    open func generate() -> Int {
        let u = ERMathHelper.random()
        return self.cumulated[self.cumulated.rangeSearch(with: u)!.from].x
    }
    
    open func generate(count: Int) -> [Int] {
        var arr = [Int](repeating: 0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
}
