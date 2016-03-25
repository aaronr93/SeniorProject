//
//  DestinationClassUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/24/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class DestinationClassUnitTests: XCTestCase {
    let testObject = Destination(name: "test", id: "testid")

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testObject)
        XCTAssert(testObject.name == "test")
        XCTAssert(testObject.id == "testid")
    }


}
