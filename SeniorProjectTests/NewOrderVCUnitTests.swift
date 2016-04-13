//
//  NewOrderVCUnitTests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 4/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini

class NewOrderVCUnitTests: XCTestCase {
    
    var test: NewOrderViewController!

    override func setUp() {
        super.setUp()
        test = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("newOrder") as! NewOrderViewController
    }

    func test_instantiate() {
        XCTAssertNotNil(test.order)
        XCTAssertNotNil(test.current)
        XCTAssertNotNil(test.user)
        XCTAssertNil(test.delegate)
    }
    
    func test_numberOfRowsInSection() {
        var numberOfRows: Int!
        
        numberOfRows = test.tableView(test.tableView, numberOfRowsInSection: 0)
        XCTAssert(numberOfRows == 1)
        
        numberOfRows = test.tableView(test.tableView, numberOfRowsInSection: 1)
        XCTAssert(numberOfRows == 1 + test.order.foodItems.count)
        
        numberOfRows = test.tableView(test.tableView, numberOfRowsInSection: 2)
        XCTAssert(numberOfRows == test.deliverySectionTitles.count)
        
        numberOfRows = test.tableView(test.tableView, numberOfRowsInSection: 3)
        XCTAssert(numberOfRows == 0)
    }
    
    func test_titleForHeaderInSection() {
        var title: String!
        
        title = test.tableView(test.tableView, titleForHeaderInSection: 0)
        XCTAssert(title == "Restaurant")
        
        title = test.tableView(test.tableView, titleForHeaderInSection: 1)
        XCTAssert(title == "Food")
        
        title = test.tableView(test.tableView, titleForHeaderInSection: 2)
        XCTAssert(title == "Delivery")
        
        title = test.tableView(test.tableView, titleForHeaderInSection: 3)
        XCTAssertTrue(title.isEmpty)
    }
    
    func test_getTextFor() {
        test.order.deliveredBy = "test"
        test.order.destination.name = "test"
        test.order.expiresIn = "test"
        
        var result: String!
        
        for i in 0..<5 {
            result = test.getTextFor(i)
            if i <= 2 {
                XCTAssert(result == "test")
            } else {
                XCTAssertTrue(result.isEmpty)
            }
        }
    }
    
    func test_heightForRowAtIndexPath() {
        var result: CGFloat!
        
        result = test.tableView(test.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssert(result == 44)
        
        result = test.tableView(test.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        XCTAssert(result == 44)
        
        result = test.tableView(test.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 2))
        XCTAssert(result == 44)
        
        for i in 3..<20 {
            result = test.tableView(test.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: i))
            XCTAssert(result == 44)
        }
        
        test.order.addFoodItem(Food(name: "test", description: "test"))
        
        result = test.tableView(test.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        XCTAssert(result == 60)
        
        result = test.tableView(test.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 1))
        XCTAssert(result == 44)
    }
    
    func test_editingStyleForRowAtIndexPath() {
        var style: UITableViewCellEditingStyle!
        
        for i in 0..<20 {
            style = test.tableView(test.tableView, editingStyleForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: i))
            
            XCTAssert(style == UITableViewCellEditingStyle.None)
            
        }
    }
    
    func test_canEditRowAtIndexPath() {
        var canEdit: Bool!
        
        for i in 0..<20 {
            canEdit = test.tableView(test.tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: i))
            if i == 1 {
                XCTAssertTrue(canEdit)
            } else {
                XCTAssertFalse(canEdit)
            }
        }
    }
    
    func test_commitEditingStyle() {
        test.order.addFoodItem(Food(name: "test", description: "test"))
        XCTAssert(test.order.foodItems.count == 1)
        
        test.tableView(test.tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        XCTAssert(test.order.foodItems.count == 0)
        XCTAssert(test.tableView.numberOfRowsInSection(1) == 1)
    }

}
