//
//  MyOrderTableVCUnitTests.swift
//  Foodini
//
//  Created by NOT_COMP401 on 4/13/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class MyOrderTableVCUnitTests: XCTestCase {
    
    var viewController = MyOrderTableViewController()
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MySingleOrderSent") as! MyOrderTableViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController.order.orderID = "uUfEtg5Bcy"
        viewController.order.deliverToID = "oIVGu99DIm"
        viewController.order.deliverTo = "Nac Zafziger"
        viewController.order.isAnyDriver = false
        viewController.order.orderState = OrderState.Available
        viewController.order.destination = Destination(name: "42 Pine St, Sydney", id: "Oc5wTWzAXA")
        viewController.order.restaurant = Restaurant(name: "Sheetz")
        viewController.order.restaurant.loc = PFGeoPoint(latitude: 37.388702, longitude: -79.90052)
        
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        viewController.order = Order()
    }
    
    func testInstantiation() {
        XCTAssert(viewController.sectionHeaders == ["Restaurant", "Food", "Delivery"])
        XCTAssert(viewController.deliverySectionTitles == ["Delivered By", "Location", "Expires In"])
        XCTAssertNotNil(viewController.order)
        XCTAssertNotNil(viewController.manip)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //from Zach's getThatOrder:
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
        let deliverySectionTitles = ["Delivered By", "Location", "Expires In"]
        viewController.order.deliverTo = "testdeliveredby"
        viewController.order.destination.name = "testdestination"
        viewController.order.expiresIn = "testexpiration"
        let testValues = ["testdeliveredby", "testdestination", "testexpiration"]
        
        for row in rows{
            let indexPath = NSIndexPath(forRow: row, inSection: 2)
            let testCell = viewController.cellForDeliverySection(tv, cellForRowAtIndexPath: indexPath) as! DeliveryItemCell
            XCTAssertEqual(testCell.deliveryTitle.text,deliverySectionTitles[row])
            XCTAssertEqual(testCell.value.text, testValues[row])
        }
        
        
    }
    
    func testNumRows() {
        let indexes = [0,1,2]
        var numbers = [1, viewController.order.foodItems.count, 3]
        if(viewController.order.orderState != OrderState.Available) { numbers[2] = 2 }//ie, if expired is hidden
        for index in indexes{
            XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: index), numbers[index])
        }
    }
}
