//
//  GetThatOrderTableViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse
import Bolts

class GetThatOrderTableViewControllerUnitTests: XCTestCase {
    var viewController: GetThatOrderTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("getThatOrder") as! GetThatOrderTableViewController
        
        viewController.order.orderID = "6cnOqhQqBC"
        viewController.order.deliverToID = "dhCgFcy0zd"
        viewController.order.deliverTo = "aaronr"
        viewController.order.isAnyDriver = false
        viewController.order.orderState = OrderState.Available
        viewController.order.destination = Destination(name: "My house", id: "jzLz3rLq0A")
        viewController.order.restaurant = Restaurant(name: "Pilot Travel Center")
        viewController.order.restaurant.loc = PFGeoPoint(latitude: 37.388702, longitude: -79.90052)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        viewController.order = Order()
    }
    
    func testInstantiation() {
        XCTAssertNotNil(viewController.order)
        XCTAssertNotNil(viewController.manip)
        XCTAssert(viewController.sectionHeaders == ["Restaurant", "Food", "Delivery"])
        XCTAssert(viewController.deliverySectionTitles == ["Deliver To", "Location", "Expires In"])
    }
    
    //driverAction can't easily be unit tested since it calls functions that call asynchronous functions, however the functions it calls can be unit tested
    
    
    
    func testRowsInSection(){
        let indexes = [0,1,2]
        let numbers = [1, viewController.order.foodItems.count, viewController.deliverySectionTitles.count]
        for index in indexes{
            XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: index), numbers[index])
        }
    }
    
   //no easy test for testCellForRowAtIndexPath(), but all the sections are tested below
    
    func testCellForRestaurantSection(){
        let tv = viewController.tableView
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        viewController.order.restaurant.name = "test"
        let testCell = viewController.cellForRestaurantSection(tv, cellForRowAtIndexPath: indexPath) as! RestaurantCell
        XCTAssertEqual(testCell.name.text, "Test")
        
    }
    
    func testCellForFoodSection(){
        let tv = viewController.tableView
        viewController.order.foodItems = [Food(name: "testname", description: "testdescription"), Food(name: nil, description: nil), Food(name:nil, description: "testdescription"), Food(name:"testname", description: nil)]
        for (index,item) in viewController.order.foodItems.enumerate(){
            let indexPath = NSIndexPath(forRow: index, inSection: 1)
            let testCell = viewController.cellForFoodSection(tv, cellForRowAtIndexPath: indexPath) as! FoodItemCell
            if (item.name != nil){
                XCTAssertEqual(testCell.foodItem.text, "testname")
            } else{
                XCTAssertEqual(testCell.foodItem.text, "")
            }
            if(item.description != nil){
                XCTAssertEqual(testCell.foodDescription.text, "testdescription")
            } else{
                XCTAssertEqual(testCell.foodDescription.text, "")
            }
            
        }
        
        
    }
    
    func testCellForDeliverySection(){
        let tv = viewController.tableView
        
        let rows = [0,1,2]
        let deliverySectionTitles = ["Deliver To", "Location", "Expires In"]
        viewController.order.deliverTo = "testdeliverto"
        viewController.order.destination.name = "testdestination"
        viewController.order.expiresIn = "testexpiration"
        let testValues = ["testdeliverto", "testdestination", "testexpiration"]
        
        for row in rows{
            let indexPath = NSIndexPath(forRow: row, inSection: 2)
            let testCell = viewController.cellForDeliverySection(tv, cellForRowAtIndexPath: indexPath) as! DeliveryItemCell
            XCTAssertEqual(testCell.deliveryTitle.text,deliverySectionTitles[row])
            XCTAssertEqual(testCell.value.text, testValues[row])
        }
        
        
    }
    
    //no unit test for viewWillAppear... it's only calling other (asynchronous) functions
        
    
    //Not sure why the below tests are in this section...
   
    //fetching an order
    func testGetThatOrder(){
        //test fetching an order
        
        let readyExpectation = expectationWithDescription("ready")
        
        //initially the order should be available
        XCTAssert(viewController.order.orderState == OrderState.Available)
        viewController.order.acquire() {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssertTrue(viewController.order.orderState == OrderState.Acquired)
    }
    
    //paying for an order
    func testPayForOrder(){
        //test paying for an order
        
        let readyExpectation = expectationWithDescription("ready")
        let currentUser = PFUser.currentUser()!
        
        //initially the order should be acquired
        viewController.order.orderState == OrderState.Acquired
        viewController.order.deliveredBy = currentUser.username!
        viewController.order.deliveredByID = currentUser.objectId!

        viewController.order.payFor() {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
       
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssert(self.viewController.order.orderState == OrderState.PaidFor)

        
    }
   
    
}
