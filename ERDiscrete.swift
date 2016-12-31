//
//  ERDiscrete.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 29..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

internal struct DiscreteMapPair: Equatable, RangeSearchable {
    let x: Int
    let y: Double
    var keyword: Double {
        return self.y
    }
    
    init(x: Int, y: Double) {
        self.x = x
        self.y = y
    }
    
    static func ==(lhs: DiscreteMapPair, rhs: DiscreteMapPair) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public class ERDiscreteMachine : RandomVariable {
    let cumulated: [DiscreteMapPair]
    
    init(histogram: [DiscreteMapPair]) {
        precondition(histogram.count != 0, "Empty Histogram!")
        let sum = histogram.reduce(0.0) { result, coord in result + (coord.y >= 0.0 ? coord.y: 0.0) }
        var cumulative = [DiscreteMapPair](repeating: DiscreteMapPair(x: 0, y: 0.0), count: histogram.count+1)
        var cumsum = 0.0
        for i in 0..<histogram.count {
            cumulative[i] = DiscreteMapPair(x: histogram[i].x, y: cumsum / sum)
            cumsum += (histogram[i].y >= 0.0 ? histogram[i].y : 0.0)
        }
        // Dummy
        cumulative[cumulative.count-1] = DiscreteMapPair(x: histogram.last!.x + 1, y: 1.0)
        self.cumulated = cumulative
    }
    
    func generate() -> Int {
        let u = Double(arc4random())/Double(UINT32_MAX)
        return self.cumulated[self.cumulated.rangeSearch(with: u)!.from].x
    }
    
    func generate(count: Int) -> [Int] {
        var arr = [Int](repeating: 0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
}

public class ERDiscreteGenerator<T> : RandomVariable {
    private let discreteMachine: ERDiscreteMachine
    private let variable: [T]
    
    fileprivate init(x: [T], probability: [Double]) {
        precondition(x.count == probability.count, "Histogram does not match")
        self.variable = x
        var histogram = [DiscreteMapPair]()
        for i in 0..<probability.count {
            histogram.append(DiscreteMapPair(x: i, y: probability[i]))
        }
        self.discreteMachine = ERDiscreteMachine(histogram: histogram)
    }
    
    func generate() -> T {
        return self.variable[discreteMachine.generate()]
    }
    
    func generate(count: Int) -> [T] {
        return discreteMachine.generate(count: count).map { index in
            return self.variable[index]
        }
    }
}

public class ERDiscreteGeneratorBuilder<T> {
    private var variable: [T]
    private var probability: [Double]
    
    init () {
        self.variable = []
        self.probability = []
    }
    
    public func append(x: T, p: Double) -> Self {
        self.variable.append(x)
        self.probability.append(p)
        return self
    }
    
    public func create() -> ERDiscreteGenerator<T> {
        return ERDiscreteGenerator(x: variable, probability: probability)
    }
}
