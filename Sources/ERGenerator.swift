//
//  RandomVariable.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 28..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

protocol RandomVariable {
    associatedtype T
    func generate() -> T
    func generate(count: Int) -> [T]
}

public class ERDiscreteGeneratorBuilder<T> {
    private var variable: [T]
    private var probability: [Double]
    
    public init() {
        self.variable = []
        self.probability = []
    }
    
    public func append(x: T, p: Double) -> Self {
        self.variable.append(x)
        self.probability.append(p)
        return self
    }
    
    public func create() -> ERDiscrete<T> {
        return ERDiscrete(x: variable, probability: probability)
    }
}

public class ERContinuousGeneratorFactory {
    private var from: Double
    private var to: Double
    
    public init(from: Double, to: Double) {
        self.from = from
        self.to = to
    }
    
    public func pdf(_ f: @escaping ((Double)->Double), partition: Int = 50) -> ERContinuousPDF {
        return ERContinuousPDF(from: self.from, to: self.to, partition: partition, pdf: f)
    }
    
    public func cdf(_ f: @escaping ((Double)->Double)) -> ERContinuousCDF {
        return ERContinuousCDF(from: self.from, to: self.to, cdf: f)
    }
    
    public func inverseCDF(_ f: @escaping ((Double)->Double)) -> ERContinuousInvCDF {
        return ERContinuousInvCDF(from: self.from, to: self.to, invcdf: f)
    }
}
