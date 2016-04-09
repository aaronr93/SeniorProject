//
//  RestaurantsNewOrderTVCUnitTests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 4/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject

class RestaurantsNewOrderTVCUnitTests: XCTestCase {
    
    var test: RestaurantsNewOrderTableViewController!

    override func setUp() {
        super.setUp()
        test = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chooseRestaurant") as! RestaurantsNewOrderTableViewController
    }
    
    func test_instantiate() {
        XCTAssertNotNil(test.POIs)
        XCTAssert(test.currentCell == 0)
        XCTAssertNil(test.delegate)
        XCTAssertFalse(test.selectedSomething)
        XCTAssertNotNil(test.currentLocation)
    }
    
    func test_addLocalPOIs() {
        let query = "Food"
        let readyExpectation = expectationWithDescription("ready")
        
        //initially the order should be available
        XCTAssert(test.POIs.restaurants.count == 0)
        test.POIs.searchFor(query, aroundLocation: test.currentLocation) {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssertTrue(test.POIs.restaurants.count > 0)
    }
    
    func test_numberOfRowsInSection() {
        let rows = test.tableView(test.tableView, numberOfRowsInSection: 0)
        XCTAssert(rows == 0)
    }
    
    func test_didSelectRowAtIndexPath() {
        let query = "Food"
        let readyExpectation = expectationWithDescription("ready")
        
        //initially the order should be available
        XCTAssert(test.POIs.restaurants.count == 0)
        test.POIs.searchFor(query, aroundLocation: test.currentLocation) {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        test.delegate = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("newOrder") as! NewOrderViewController
        
        test.tableView(test.tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssert(test.currentCell == 0)
        XCTAssertTrue(test.selectedSomething)
    }

}
