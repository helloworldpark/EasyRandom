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


