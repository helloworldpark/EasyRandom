//
//  EasyRandom_macosTests.swift
//  EasyRandom-macosTests
//
//  Created by LinePlus on 2017. 1. 1..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import XCTest
@testable import EasyRandom

class EasyRandom_macosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let discreteBuilder = ERDiscreteBuilder<String>()
        discreteBuilder.append("Foo", 0.42).append("Bar", 0.58)
        let discreteRandoms = discreteBuilder.create().generate(count: 10000)
        for foobar in discreteRandoms {
            print(foobar)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
