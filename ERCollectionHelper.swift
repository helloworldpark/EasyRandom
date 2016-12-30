//
//  ERCollectionHelper.swift
//  EasyRandom
//
//  Created by LinePlus on 2016. 12. 30..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

protocol RangeSearchable {
    associatedtype T: Comparable
    var searchby: T { get }
}

extension Collection where Iterator.Element: RangeSearchable, Index == Int {
    func rangeSearch(with y: Iterator.Element.T) -> (from: Int, to: Int)? {
        guard y >= self[0].searchby && y < self[self.endIndex-1].searchby else {
            return nil
        }
        
        var startIdx = 0
        var lastIdx = self.endIndex - self.startIndex - 1
        var idx = (lastIdx + startIdx) / 2
        var isYBigger = self[idx].searchby <= y
        var isYSmaller = y < self[idx+1].searchby
        while (isYBigger && isYSmaller) == false {
            if isYBigger == true {
                startIdx = idx
            } else if isYSmaller == true {
                lastIdx = idx
            }
            idx = (lastIdx + startIdx)/2
            
            isYBigger = self[idx].searchby <= y
            isYSmaller = y < self[idx+1].searchby
        }
        return (from: idx, to: idx+1)
    }
}

extension Collection where Iterator.Element == Coord2D, Index == Int {
    
    func sorted() -> [Coord2D] {
        return self.sorted { c1, c2 in
            return c1.y < c2.y
        }
    }
    
    func xrange(y: Double) -> (x1: Double, x2: Double)? {
        guard let indexRange = self.rangeSearch(with: y) else {
            return nil
        }
        return (x1: self[indexRange.from].x, x2: self[indexRange.to].x)
        
        
//        guard y >= self[0].y && y < self[self.endIndex-1].y else {
//            return nil
//        }
//        
//        var startIdx = 0
//        var lastIdx = self.endIndex - self.startIndex - 1
//        var idx = (lastIdx + startIdx) / 2
//        var isYBigger = self[idx].y <= y
//        var isYSmaller = y < self[idx+1].y
//        while (isYBigger && isYSmaller) == false {
//            if isYBigger == true {
//                startIdx = idx
//            } else if isYSmaller == true {
//                lastIdx = idx
//            }
//            idx = (lastIdx + startIdx)/2
//            
//            isYBigger = self[idx].y <= y
//            isYSmaller = y < self[idx+1].y
//        }
//        return (x1: self[idx].x, x2: self[idx+1].x)
    }
}
