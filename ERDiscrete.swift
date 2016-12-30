//
//  ERDiscrete.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 29..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

public class ERDiscrete : RandomVariable {
    let histogram: [Coord2D]
    
    init(histogram: [Coord2D]) {
        precondition(histogram.count != 0, "Empty Histogram!")
        self.histogram = histogram
    }
    
    func generate() -> Double {
        let u = Double(arc4random())/Double(UINT32_MAX)
        return u
    }
    
    func generate(count: Int) -> [Double] {
        return [0.0]
    }
}
