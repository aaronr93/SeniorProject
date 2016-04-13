//
//  CustomerDestinationsUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class CustomerDestinationsUnitTests: XCTestCase {
    let testObject = CustomerDestinations()
    var result = true
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testObject.history)
        XCTAssertNotNil(testObject.destinationID)
        XCTAssertNotNil(testObject.destinationQuery)
        XCTAssertNotNil(testObject.me)
    }
    
    func testAdd(){
        //positive test
        XCTAssert(testObject.history.count == 0)
        let testDest = Destination(name: "test", id: "test")
        testObject.add(testDest)
        XCTAssert(testObject.history.count == 1)
        //negative test
        testObject.add(testDest)
        XCTAssert(testObject.history.count == 1)
    }
    
    func testRemove(){
        //negative test
        XCTAssert(testObject.history.count == 0)
        let testDest = Destination(name: "test", id: "test")
        testObject.add(testDest)
        XCTAssert(testObject.history.count == 1)
        let badTestDest = Destination(name: "test2", id: "test2")
        testObject.remove(badTestDest)
        XCTAssert(testObject.history.count == 1)
        //positive test
        testObject.remove(testDest)
        XCTAssert(testObject.history.count == 0)

    }
    
    func testAddDestinationItemToDB(){
        //can't test the error case automatically
        XCTAssert(testObject.history.count == 0)
        var result = true
        testObject.addDestinationItemToDB("test", completion: {success in result = success})
        XCTAssertTrue(result)
        
        
    }
    
    func testGetDestinationItemsFromParse(){
        //can't test the error case
        XCTAssert(testObject.history.count == 0)
        testObject.getDestinationItemsFromParse({success in self.result = success})
        XCTAssertTrue(result)
    }
    
}
