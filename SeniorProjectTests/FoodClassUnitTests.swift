//
//  FoodClassTests.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/15/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini

class FoodClassUnitTests: XCTestCase {
    
    let testFood = Food(name: "test", description: "more tests")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func TestFieldsSet() {
        XCTAssertNotNil(testFood.description)
        XCTAssertNotNil(testFood.name)
    }
}