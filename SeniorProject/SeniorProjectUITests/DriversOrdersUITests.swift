//
//  DriversOrdersUITests.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/29/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class DriversOrdersUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testrequestsForMeTap() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        //XCUIApplication().navigationBars["I'm Picking Up Food"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).pressForDuration(0.05)
        
        
    }
    
    
    
    
    

}
