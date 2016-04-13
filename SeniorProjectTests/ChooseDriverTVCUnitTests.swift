//
//  ChooseDriverTVCUnitTests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 4/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class ChooseDriverTVCUnitTests: XCTestCase {
    
    var test: ChooseDriverTableViewController!

    override func setUp() {
        super.setUp()
        test = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chooseDrivers") as! ChooseDriverTableViewController
        test.delegate = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("newOrder") as! NewOrderViewController
    }

    func test_instantiate() {
        XCTAssertNotNil(test.drivers)
        XCTAssertTrue(test.chosenDriver.isEmpty)
        XCTAssertTrue(test.chosenDriverID.isEmpty)
        XCTAssertFalse(test.isAnyDriver)
        XCTAssertNotNil(test.delegate)
    }
    
    func test_numberOfSections() {
        var sections: Int!
        
        XCTAssert(test.drivers.availabilities.count == 0)
        sections = test.numberOfSectionsInTableView(test.tableView)
        XCTAssert(sections == 1)
        
        test.drivers.addDriver(PFUser())
        XCTAssert(test.drivers.drivers.count == 1)
        sections = test.numberOfSectionsInTableView(test.tableView)
        XCTAssert(sections == 2)
    }
    
    func test_numberOfRowsInSection() {
        test.drivers.clear()
        XCTAssert(test.tableView(test.tableView, numberOfRowsInSection: 0) == 1)
        
        test.drivers.addDriver(PFUser())
        XCTAssert(test.drivers.drivers.count == 1)
        XCTAssert(test.tableView(test.tableView, numberOfRowsInSection: 1) == 1)
    }
    
    func test_titleForHeaderInSection() {
        var str: String!
        
        str = test.tableView(test.tableView, titleForHeaderInSection: 0)
        XCTAssertTrue(str.isEmpty)
        
        str = test.tableView(test.tableView, titleForHeaderInSection: 1)
        XCTAssert(str == "Choose a driver")
    }
    
}
