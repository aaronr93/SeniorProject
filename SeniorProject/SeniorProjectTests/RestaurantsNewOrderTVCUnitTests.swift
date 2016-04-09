//
//  RestaurantsNewOrderTVCUnitTests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 4/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import MapKit

class RestaurantsNewOrderTVCUnitTests: XCTestCase {
    
    var test: RestaurantsNewOrderTableViewController!

    override func setUp() {
        super.setUp()
        test = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chooseRestaurant") as! RestaurantsNewOrderTableViewController
        test.currentLocation = CurrentLocation()
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
        let loc = CLLocation(latitude: 41, longitude: 80)
        let coord = loc.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        let region = MKCoordinateRegion(center: coord, span: span)
        test.POIs.searchFor(query, inRegion: region, withLocation: loc) {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssertTrue(test.POIs.restaurants.count > 0)
    }
    
    func test_didSelectRowAtIndexPath() {
        let query = "Food"
        let readyExpectation = expectationWithDescription("ready")
        
        //initially the order should be available
        XCTAssert(test.POIs.restaurants.count == 0)
        let loc = CLLocation(latitude: 41, longitude: 80)
        let coord = loc.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        let region = MKCoordinateRegion(center: coord, span: span)
        test.POIs.searchFor(query, inRegion: region, withLocation: loc) {
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
