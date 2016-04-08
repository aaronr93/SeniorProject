//
//  InterfaceManipulationTests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 4/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class InterfaceManipulationTests: XCTestCase {
    
    var manip: InterfaceManipulation!

    override func setUp() {
        super.setUp()
        manip = InterfaceManipulation()
    }
    
    // Customer side

    func test_customerStyle_Available() {
        let button = UIButton()
        manip.setCustomerStyleFor(button, toReflect: OrderState.Available)
        XCTAssert(button.titleLabel?.text == "Cancel")
        XCTAssert(button.titleColorForState(.Normal) == .redColor())
        XCTAssertTrue(button.enabled)
    }
    
    func test_customerStyle_Acquired() {
        let button = UIButton()
        manip.setCustomerStyleFor(button, toReflect: OrderState.Acquired)
        XCTAssert(button.titleLabel?.text == "Acquired by driver")
        XCTAssert(button.titleColorForState(.Disabled) == .grayColor())
        XCTAssertFalse(button.enabled)
    }
    
    func test_customerStyle_Deleted() {
        let button = UIButton()
        manip.setCustomerStyleFor(button, toReflect: OrderState.Deleted)
        XCTAssert(button.titleLabel?.text == "Order deleted")
        XCTAssert(button.titleColorForState(.Disabled) == .grayColor())
        XCTAssertFalse(button.enabled)
    }
    
    func test_customerStyle_PaidFor() {
        let button = UIButton()
        manip.setCustomerStyleFor(button, toReflect: OrderState.PaidFor)
        XCTAssert(button.titleLabel?.text == "Order paid for by driver")
        XCTAssert(button.titleColorForState(.Disabled) == .grayColor())
        XCTAssertFalse(button.enabled)
    }
    
    func test_customerStyle_Delivered() {
        let button = UIButton()
        manip.setCustomerStyleFor(button, toReflect: OrderState.Delivered)
        XCTAssert(button.titleLabel?.text == "Reimburse driver")
        XCTAssertTrue(button.enabled)
    }
    
    func test_customerStyle_Completed() {
        let button = UIButton()
        manip.setCustomerStyleFor(button, toReflect: OrderState.Completed)
        XCTAssert(button.titleLabel?.text == "Order completed")
        XCTAssert(button.titleColorForState(.Disabled) == .grayColor())
        XCTAssertFalse(button.enabled)
    }
    
    // Driver side
    
    func test_driverStyle_Available() {
        let button = UIButton()
        manip.setDriverStyleFor(button, toReflect: OrderState.Available)
        XCTAssert(button.titleLabel?.text == "I'll get that")
        XCTAssertTrue(button.enabled)
    }
    
    func test_driverStyle_Acquired() {
        let button = UIButton()
        manip.setDriverStyleFor(button, toReflect: OrderState.Acquired)
        XCTAssert(button.titleLabel?.text == "I paid for the food")
        XCTAssertTrue(button.enabled)
    }
    
    func test_driverStyle_PaidFor() {
        let button = UIButton()
        manip.setDriverStyleFor(button, toReflect: OrderState.PaidFor)
        XCTAssert(button.titleLabel?.text == "I arrived at the delivery location")
        XCTAssertTrue(button.enabled)
    }
    
    func test_driverStyle_Delivered() {
        let button = UIButton()
        manip.setDriverStyleFor(button, toReflect: OrderState.Delivered)
        XCTAssert(button.titleLabel?.text == "Waiting for customer to reimburse")
        XCTAssertFalse(button.enabled)
    }
    
    func test_driverStyle_Completed() {
        let button = UIButton()
        manip.setDriverStyleFor(button, toReflect: OrderState.Completed)
        XCTAssert(button.titleLabel?.text == "Order completed")
        XCTAssertFalse(button.enabled)
    }

}


















