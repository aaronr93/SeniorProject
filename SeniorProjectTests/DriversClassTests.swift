//
//  DriversClassTests.swift
//  Foodini
//
//  Created by Michael Kytka on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse
import Bolts

class DriversClassTests: XCTestCase {
    
    var viewController : ChooseDriverTableViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chooseDrivers") as! ChooseDriverTableViewController
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetDriversFromDB() {
        
    }

}
