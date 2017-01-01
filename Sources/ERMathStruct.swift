//
//  ERMathStruct.swift
//  EasyRandom
//
//  Created by Helloworld Park on 2016. 12. 30..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

public typealias CubicPolynomial = (a: Double, b: Double, c:Double, d: Double)

public struct Coord2D: Equatable, RangeSearchable {
    let x: Double
    let y: Double
    var keyword: Double {
        return self.y
    }
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public static func ==(lhs: Coord2D, rhs: Coord2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public struct IntCoord2D: Equatable, RangeSearchable {
    let x: Int
    let y: Double
    var keyword: Double {
        return self.y
    }
    
    init(x: Int, y: Double) {
        self.x = x
        self.y = y
    }
    
    public static func ==(lhs: IntCoord2D, rhs: IntCoord2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
