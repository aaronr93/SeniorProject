//
//  DriverOrdersViewControllerUnitTests.swift
//  Foodini
//
//  Created by NOT_COMP401 on 4/12/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class DriverOrdersViewControllerUnitTests: XCTestCase {
    var testVC = DriverOrdersViewController()
    override func setUp() {
        super.setUp()
        testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("driverOrders") as! DriverOrdersViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testVC.driverOrders)
        XCTAssertNotNil(testVC.anyDriverOrders)
        XCTAssertEqual(testVC.sectionHeaders, ["Requests For Me", "Requests For Anyone"])
    }
    
    func testNumberOfRows(){
        let sectionAmounts = [testVC.driverOrders.count, testVC.anyDriverOrders.count]
        let tv = testVC.tableView
        for (index, amount) in sectionAmounts.enumerate(){
            XCTAssertEqual(testVC.tableView(tv, numberOfRowsInSection: index), amount)
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
