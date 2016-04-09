//
//  OrderUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class OrderUnitTests: XCTestCase {
    let testObject = Order()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testObject.restaurant)
        XCTAssertEqual(testObject.orderID, "")
        XCTAssertEqual(testObject.isAnyDriver, false)
        XCTAssertEqual(testObject.expiresIn, "")
        XCTAssertEqual(testObject.expiresHours, 0)
        XCTAssertEqual(testObject.expiresMinutes, 0)
        XCTAssertEqual(testObject.deliverTo, "")
        XCTAssertEqual(testObject.deliverToID, "")
        XCTAssertEqual(testObject.deliveredBy, "")
        XCTAssertEqual(testObject.deliveredByID, "")
        XCTAssertNotNil(testObject.destination)
        XCTAssertNotNil(testObject.foodItems)
        XCTAssertEqual(testObject.orderState, OrderState.Available)
        XCTAssertEqual(testObject.itemsForOrderQuery, PFQuery(className: "OrderedItems"))
    }
    
    func testAddFoodItem(){
        let item = Food(name: "test", description: "test")
        testObject.foodItems.append(item)
        XCTAssertEqual(testObject.foodItems.count, 1)
        testObject.addFoodItem(item)
        XCTAssertEqual(testObject.foodItems.count, 1)
        testObject.addFoodItem(Food(name: "test2", description: "test2"))
        XCTAssertEqual(testObject.foodItems.count, 2)
    }
    
    func testRemoveFoodItem(){
        let item = Food(name: "test", description: "test")
        testObject.foodItems.append(item)
        XCTAssertEqual(testObject.foodItems.count, 1)
        testObject.removeFoodItem(Food(name: "test2", description: "test2"))
        XCTAssertEqual(testObject.foodItems.count, 1)
        testObject.removeFoodItem(item)
        XCTAssertEqual(testObject.foodItems.count, 0)
        testObject.foodItems.append(item)
        XCTAssertEqual(testObject.foodItems.count, 1)
        testObject.removeFoodItem(0)
        XCTAssertEqual(testObject.foodItems.count, 0)
        
    }
    
    func testFoodItemsToPFObjects(){
        let item1 = Food(name: "test", description: "test")
        let item2 = Food(name: "test2", description: "test2")
        let results:[PFObject] = testObject.foodItemsToPFObjects([item1, item2])
        XCTAssertEqual(results[0]["foodDescription"] as? String, "test")
        XCTAssertEqual(results[1]["foodDescription"] as? String, "test2")
    }
    
    func testAddFoodItemsToOrderInDB(){
        let item1 = Food(name: "test", description: "test")
        let item2 = Food(name: "test2", description: "test2")
        
    }
}
