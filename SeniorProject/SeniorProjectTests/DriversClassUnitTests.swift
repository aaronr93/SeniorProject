//
//  DriversClassUnitTests.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/29/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse
import Bolts

class DriversClassTests: XCTestCase {
    
    var viewController : ChooseDriverTableViewController!
    
    let testDrivers = Drivers()
    var testRestaurants = PFObject(className: "Sheets")
    let driver = PFUser(className: "Teast")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chooseDrivers") as! ChooseDriverTableViewController
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDriversFieldsSet() {
        XCTAssertNotNil(testDrivers.list)
        XCTAssertNil(testDrivers.restaurant)
    }
    
    func testGetDriversFromDB() {
        
    }
    
    func testAdd() {
        testDrivers.add(driver)
        XCTAssert(testDrivers.list.count == 1)
        testDrivers.add(driver)
        XCTAssert(testDrivers.list.count == 1)
    }
    
}