//
//  SettingsClassTests.swift
//  Foodini
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class SettingsClassTests: XCTestCase {
    
    var testSettings = Settings(active: true)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActive(){
        XCTAssertTrue(testSettings.active)
    }
    
    
}
