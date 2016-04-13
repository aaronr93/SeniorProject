//
//  OrderUnitTests.swift
//  Foodini
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class OrderUnitTests: XCTestCase {
    var test: Order!
    
    override func setUp() {
        super.setUp()
        test = Order()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(test.restaurant)
        XCTAssertEqual(test.orderID, "")
        XCTAssertEqual(test.isAnyDriver, false)
        XCTAssertEqual(test.expiresIn, "")
        XCTAssertEqual(test.expiresHours, 0)
        XCTAssertEqual(test.expiresMinutes, 0)
        XCTAssertEqual(test.deliverTo, "")
        XCTAssertEqual(test.deliverToID, "")
        XCTAssertEqual(test.deliveredBy, "")
        XCTAssertEqual(test.deliveredByID, "")
        XCTAssertNotNil(test.destination)
        XCTAssertNotNil(test.foodItems)
        XCTAssertEqual(test.orderState, OrderState.Available)
        XCTAssertEqual(test.itemsForOrderQuery, PFQuery(className: "OrderedItems"))
    }
    
    func testAddFoodItem(){
        let item = Food(name: "test", description: "test")
        test.foodItems.append(item)
        XCTAssertEqual(test.foodItems.count, 1)
        test.addFoodItem(item)
        XCTAssertEqual(test.foodItems.count, 1)
        test.addFoodItem(Food(name: "test2", description: "test2"))
        XCTAssertEqual(test.foodItems.count, 2)
        test.addFoodItem(item)
        XCTAssertEqual(test.foodItems.count, 2)
    }
    
    func testRemoveFoodItem(){
        let item = Food(name: "test", description: "test")
        test.foodItems.append(item)
        XCTAssertEqual(test.foodItems.count, 1)
        test.removeFoodItem(Food(name: "test2", description: "test2"))
        XCTAssertEqual(test.foodItems.count, 1)
        test.removeFoodItem(item)
        XCTAssertEqual(test.foodItems.count, 0)
        test.foodItems.append(item)
        XCTAssertEqual(test.foodItems.count, 1)
        test.removeFoodItem(0)
        XCTAssertEqual(test.foodItems.count, 0)
        
    }
    
    func testFoodItemsToPFObjects(){
        test.orderID = "uUfEtg5Bcy"
        let item1 = Food(name: "test", description: "test")
        let item2 = Food(name: "test2", description: "test2")
        let results:[PFObject] = test.foodItemsToPFObjects([item1, item2])
        XCTAssertEqual(results[0]["foodDescription"] as? String, "test")
        XCTAssertEqual(results[1]["foodDescription"] as? String, "test2")
    }
    
    func testAddFoodItemsToOrderInDB(){
        _ = Food(name: "test", description: "test")
        _ = Food(name: "test2", description: "test2")
        
    }
    
    //other functions should be tested manually or through ui tests
}
