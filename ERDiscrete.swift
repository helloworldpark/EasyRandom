//
//  ERDiscrete.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 29..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

public class ERDiscrete : RandomVariable {
    let cumulated: [Coord2D]
    
    init(histogram: [Coord2D]) {
        precondition(histogram.count != 0, "Empty Histogram!")
        let sum = histogram.reduce(0.0) { result, coord in result + (coord.y >= 0.0 ? coord.y: 0.0) }
        var cumulative = [Coord2D](repeating: Coord2D(x: 0.0, y: 0.0), count: histogram.count+1)
        var cumsum = 0.0
        for i in 0..<histogram.count {
            cumulative[i] = Coord2D(x: histogram[i].x, y: cumsum / sum)
            cumsum += (histogram[i].y >= 0.0 ? histogram[i].y : 0.0)
        }
        // Dummy
        cumulative[cumulative.count-1] = Coord2D(x: histogram.last!.x + 1.0, y: 1.0)
        self.cumulated = cumulative
    }
    
    func generate() -> Double {
        let u = Double(arc4random())/Double(UINT32_MAX)
        return self.cumulated.xrange(y: u)!.x1
    }
    
    func generate(count: Int) -> [Double] {
        var arr = [Double](repeating: 0.0, count: count)
        for i in 0..<arr.count {
            arr[i] = self.generate()
        }
        return arr
    }
}
