//
//  ERCollectionHelper.swift
//  EasyRandom
//
//  Created by Helloworld Park on 2016. 12. 30..
//  Copyright © 2016년 Helloworld Park. All rights reserved.
//

import Foundation

/*
 * Protocol for searching the interval for a given number in a collection
 */
protocol RangeSearchable {
    associatedtype T: Comparable
    var keyword: T { get }
}

extension Collection where Iterator.Element: RangeSearchable, Index == Int {
    /*
     * Given y, find index i s.t. self[i] <= y < self[i+1]
     * Assumes that the collection is sorted
     * Uses Binary Search Algorithm
     */
    func rangeSearch(with y: Iterator.Element.T) -> (from: Int, to: Int)? {
        guard y >= self[0].keyword && y < self[self.endIndex-1].keyword else {
            return nil
        }
        
        var startIdx = 0
        var lastIdx = self.endIndex - self.startIndex - 1
        var idx = (lastIdx + startIdx) / 2
        var isYBigger = self[idx].keyword <= y
        var isYSmaller = y < self[idx+1].keyword
        while (isYBigger && isYSmaller) == false {
            if isYBigger == true {
                startIdx = idx
            } else if isYSmaller == true {
                lastIdx = idx
            }
            idx = (lastIdx + startIdx)/2
            
            isYBigger = self[idx].keyword <= y
            isYSmaller = y < self[idx+1].keyword
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
}
