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

    
    func testAMakeDummyData() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
        
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Test")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("january")
        app.buttons["Go"].tap()
        
    
        let iWantFoodButton = app.buttons["I want food"]
        iWantFoodButton.tap()
        
        let tablesQuery = app.tables
        let selectRestaurantStaticText = tablesQuery.staticTexts["Select restaurant..."]
        selectRestaurantStaticText.tap()
        tablesQuery.staticTexts["Nonni's Corner Trattoria"].tap()
        
        tablesQuery.staticTexts["Add new food item..."].tap()
        tablesQuery.textFields["Title"].tap()
        tablesQuery.textFields["Title"].typeText("test")
        
        let doneButton = app.navigationBars["Food item"].buttons["Done"]
        doneButton.tap()
        
        let selectADriverStaticText = tablesQuery.staticTexts["Select a driver..."]
        selectADriverStaticText.tap()
        tablesQuery.staticTexts["Any driver"].tap()
        
        let selectDeliveryLocationStaticText = tablesQuery.staticTexts["Select delivery location..."]
        selectDeliveryLocationStaticText.tap()
        tablesQuery.textFields["Custom delivery location..."].tap()
        let newlocation = tablesQuery.textFields["Custom delivery location..."]
        newlocation.typeText("map")
        tablesQuery.buttons["Add"].tap()
        
        let mapStaticText = tablesQuery.staticTexts["map"]
        mapStaticText.tap()
        
        let selectExpirationTimeStaticText = tablesQuery.staticTexts["Select expiration time..."]
        selectExpirationTimeStaticText.tap()
    
        let pickerWheel = app.pickerWheels["0 hours"]
        pickerWheel.tap()
        app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("2 hours")
        
        let newOrderButton = app.navigationBars["Expires In"].buttons["New Order"]
        newOrderButton.tap()
        
        let submitButton = tablesQuery.buttons["Submit"]
        submitButton.tap()
        //submitButton.tap()
        //app.buttons["Submit"].tap()
        let iWantFoodButton2 = app.buttons["I want food"]
        iWantFoodButton2.tap()
        selectRestaurantStaticText.tap()
        tablesQuery.staticTexts["Sweet Jeanie's"].tap()
        tablesQuery.staticTexts["Add new food item..."].tap()
        tablesQuery.textFields["Title"].tap()
        tablesQuery.textFields["Title"].typeText("test")
        doneButton.tap()
        selectADriverStaticText.tap()
        tablesQuery.staticTexts["LoewSD1"].tap()
        selectDeliveryLocationStaticText.tap()
        mapStaticText.tap()
        selectExpirationTimeStaticText.tap()
        pickerWheel.tap()
        app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("2 hours")
        newOrderButton.tap()
        submitButton.tap()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
        
    }
    
    func testBRequestsForMeTap() {
        let app = XCUIApplication()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("LoewSD1")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("hello")
        app.buttons["Go"].tap()
        
        XCUIApplication().buttons["I'm picking up food"].tap()
        app.tables.cells.elementBoundByIndex(0).tap()
        
        
    }
    
    func testCRequestsForAnyoneTap() {
        let app = XCUIApplication()
        XCUIApplication().buttons["I'm picking up food"].tap()
        app.tables.cells.elementBoundByIndex(1).tap()
    }
}
