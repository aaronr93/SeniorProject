//
//  NewFoodItemViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class NewFoodItemViewControllerUnitTests: XCTestCase {
    
    var viewController: NewFoodItemTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("newFoodItem") as! NewFoodItemTableViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoggedIn(){
        XCTAssertNotNil(PFUser.currentUser())
    }
    
    func testFieldsEmpty(){
        XCTAssert(viewController.foodNameText == "")
        XCTAssert(viewController.foodDescriptionText == "")
    }
    
    
    
    
}
