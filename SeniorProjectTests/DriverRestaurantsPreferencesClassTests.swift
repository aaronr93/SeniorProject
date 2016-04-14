//
//  DriverRestaurantsPreferencesClassTests.swift
//  Foodini
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class DriverRestaurantsPreferencesClassTests: XCTestCase {
    
    var testObject = DriverRestaurantPreferences()
    var testRestaurant: String!
    let currentUser = PFUser.currentUser()!
    
    override func setUp() {
        super.setUp()
        testObject.availability = PFDriverAvailability(withoutDataWithObjectId: "Q6bySGZ85x")
        testObject.blacklist.removeAll()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Instantiate() {
        //test that all the fields have been set when making a new instance
        let test = DriverRestaurantPreferences()
        XCTAssertNotNil(test.availability)
        XCTAssertEqual(currentUser, test.driver)
        XCTAssertTrue(test.blacklist.isEmpty)
    }
    
    func test_markUnavailable() {
        let restaurant = Restaurant(name: "Sheetz")
        let obj = PFUnavailableRestaurant()
        obj.restaurant = restaurant.name
        obj.driverAvailability = currentUser
        
        testObject.markUnavailable(restaurant)

        XCTAssert(testObject.blacklist.last!.restaurant == "Sheetz")
    }
    
    func test_markAvailable() {
        let restaurant = Restaurant(name: "Sheetz")
        let obj = PFUnavailableRestaurant()
        obj.restaurant = restaurant.name
        obj.driverAvailability = currentUser
        testObject.blacklist.append(obj)
        
        testObject.markAvailable(restaurant)
        
        XCTAssertFalse(testObject.blacklist.contains(obj), "The restaurant marked as Available should be removed from the blacklist.")
    }
    
    func test_isUnavailable() {
        let restaurant = Restaurant(name: "Sheetz")
        let obj = PFUnavailableRestaurant()
        obj.restaurant = restaurant.name
        obj.driverAvailability = currentUser
        testObject.blacklist.append(obj)
        
        XCTAssertTrue(testObject.isUnavailable(restaurant))
        
        let restaurant2 = Restaurant(name: "McDonald's")
        let obj2 = PFUnavailableRestaurant()
        obj2.restaurant = restaurant2.name
        obj2.driverAvailability = currentUser
        
        XCTAssertFalse(testObject.isUnavailable(restaurant2))
    }
    
    func test_clearRestaurants() {
        let restaurant = Restaurant(name: "Sheetz")
        let obj = PFUnavailableRestaurant()
        obj.restaurant = restaurant.name
        obj.driverAvailability = currentUser
        testObject.blacklist.append(obj)
        
        let restaurant2 = Restaurant(name: "McDonald's")
        let obj2 = PFUnavailableRestaurant()
        obj2.restaurant = restaurant2.name
        obj2.driverAvailability = currentUser
        testObject.blacklist.append(obj2)
        
        testObject.clearRestaurants()
        XCTAssert(testObject.blacklist.isEmpty)
    }
    
    func test_saveAll() {
        // This function only changes stuff in Parse
    }
    
    func test_getBlacklistFromParse() {
        XCTAssertTrue(testObject.blacklist.isEmpty)
        
        testObject.getBlacklistFromParse() { result in
            if result {
                XCTAssertFalse(self.testObject.blacklist.isEmpty)
            }
        }
    }
    
    func test_getExpirationTime() {
        let availability = PFDriverAvailability()
        availability.expirationDate = NSDate().addDays(1)
        testObject.availability = availability
        let returnedString = testObject.getExpirationTime()
        XCTAssert(returnedString == ParseDate.timeLeft(availability.expirationDate))
    }
    
    
}






