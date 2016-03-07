//
//  DriverRestaurantsPreferencesClassTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class DriverRestaurantsPreferencesClassTests: XCTestCase {
    
    var testObject = DriverRestaurantPreferences()
    var testRestaurant = PFObject(className: "Restaurant")
    
    override func setUp() {
        super.setUp()
        Parse.setApplicationId("j28gc7OUqKZFc47nvyoRDPnZnaCRqh3mV8RiULMK", clientKey: "Il9Xid8E9BI7G6pkwUUQLKSO0kL9FKtwNtlSL1O3")
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFieldsSet(){
        //test that all the fields have been set when making a new instance
        XCTAssertFalse(testObject.active)
        XCTAssertNotNil(testObject.restaurants)
        XCTAssertNotNil(testObject.expirationTime)
    }
    
    func testAddRestaurant(){
        //test the addRestaurant function with positive and negative cases
        testObject.addRestaurant(testRestaurant)
        XCTAssert(testObject.restaurants.count == 1)
        //add it again to make sure it isn't added twice
        testObject.addRestaurant(testRestaurant)
        XCTAssert(testObject.restaurants.count == 1)
        
    }
    
    func testRemoveRestaurant(){
        //test the addRestaurant function with positive and negative cases
        
        testObject.addRestaurant(testRestaurant)
        XCTAssert(testObject.restaurants.count == 1)
        
        //remove it
        testObject.removeRestaurant(testRestaurant)
        XCTAssert(testObject.restaurants.count == 0)
        
        //there shouldn't be anything to remove, nothing should change
        testObject.removeRestaurant(testRestaurant)
        XCTAssert(testObject.restaurants.count == 0)
        
    }
    
    func testSetActive(){
        //test the setActive function with positive and negative cases
        
        //before adding a restaurant, shouldn't set active
        testObject.setActive()
        XCTAssertFalse(testObject.active)
        
        //should work if restaurant is added
        testObject.addRestaurant(testRestaurant)
        testObject.setActive()
        XCTAssertTrue(testObject.active)
    }
    
    func testSetInactive(){
        //test the setInactive function with positive and negative cases
        
        //shouldn't change anything if the restaurant hasn't been set active yet
        testObject.setInactive()
        XCTAssertFalse(testObject.active)
        
        //should change if the restaurant is active
        testObject.addRestaurant(testRestaurant)
        testObject.setActive()
        XCTAssertTrue(testObject.active)
        testObject.setInactive()
        XCTAssertFalse(testObject.active)
    }
    
}
