//
//  NewOrderUITests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/22/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class NewOrderUITests: SeniorProjectUITests {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    func testRestaurantTap() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        
        //not selecting a restaurant - none selected
        XCTAssertNotNil(app.tables.staticTexts["Select a Restaurant"])
        app.tables.staticTexts["Select a Restaurant"].tap()
        XCTAssertNotNil(app.navigationBars["Select Restaurant"].buttons["New Order"])
        app.navigationBars["Select Restaurant"].buttons["New Order"].tap()
        XCTAssertNotNil(app.tables.staticTexts["Select a Restaurant"])
        
        //selecting a restaurant
        app.tables.staticTexts["Select a Restaurant"].tap()
        app.tables.staticTexts["sheetz"].tap()
        XCTAssertNotNil(app.tables.staticTexts["Sheetz"])
        
        //not selecting a restaurant - already something selected
        app.tables.staticTexts["Sheetz"].tap()
        app.navigationBars["Select Restaurant"].buttons["New Order"].tap()
        XCTAssertNotNil(app.tables.staticTexts["Sheetz"])
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    func testAddFoodItem(){
        
        let app = XCUIApplication()
        //waitForExpectationsWithTimeout(10, handler: nil)
        app.buttons["I want food"].tap()
        let tablesQuery = app.tables
        tablesQuery.otherElements["FOOD"].tap()
        
        let clearTextTextField = tablesQuery.textFields.containingType(.Button, identifier:"Clear text").element
        clearTextTextField.typeText("Test")
        
        app.buttons["Next"].tap()
        app.tables.textFields["Details"].typeText("\n")
        clearTextTextField.typeText("Test")
        app.keyboards.buttons["Done"].tap()
        app.typeText("\n")
        
        
        
        /*app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        app.textFields["Enter Food Name"].typeText("test")
        app.buttons["Next"].tap()
        let enterFoodDescriptionTextField = app.textFields["Enter Food Description"]
        enterFoodDescriptionTextField.tap()
        enterFoodDescriptionTextField.typeText("test")
        app.keyboards.buttons["Done"].tap()*/
        
        //should take us to edit food item screen, which means the food item was created
        app.tables.element.cells.elementBoundByIndex(1).tap()
        XCTAssertNotNil(clearTextTextField)
        app.navigationBars["Food item"].buttons["New Order"].tap()
        
    }
    
    
    func testSelectDriver(){
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        
        //need to select a restaurant first
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Select a Restaurant"].tap()
        tablesQuery.staticTexts["sheetz"].tap()
        
        //can't test the values in cells, so basically just making sure it doesn't crash and goes to correct view
        let deliveredByStaticText = tablesQuery.staticTexts["Delivered by"]
        deliveredByStaticText.tap()
        tablesQuery.staticTexts["testAccount"].tap()
        XCTAssertNotNil(app.navigationBars["SeniorProject.ChooseDriverTableView"].buttons["New Order"])
        deliveredByStaticText.tap()
        XCTAssertNotNil(app.navigationBars["SeniorProject.ChooseDriverTableView"].buttons["New Order"])
        tablesQuery.staticTexts["Any driver"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }
    
    func testSelectLocation(){
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery.staticTexts["Location"].tap()
        tablesQuery.textFields["Custom delivery location..."].tap()
        tablesQuery2.cells.containingType(.Button, identifier:"Add").childrenMatchingType(.TextField).element.typeText("test")
        tablesQuery.buttons["Add"].tap()
        app.navigationBars["Select Delivery Location"].buttons["New Order"].tap()
        tablesQuery.staticTexts["Location"].tap()
        //new table item should exist, tapping it should not break
        XCTAssertNotNil(app.tables.element.cells.elementBoundByIndex(1))
        app.tables.element.cells.elementBoundByIndex(1).tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
        
        
    }
    
    func testSelectExpiration(){
        
        let app = XCUIApplication()
        let cancelButton = app.navigationBars["New Order"].buttons["Cancel"]
        app.buttons["I want food"].tap()
        
        let app2 = app
        app2.tables.staticTexts["Expires In"].tap()
        app2.pickerWheels.element.adjustToPickerWheelValue("2 Hours")
        XCTAssertNotNil(app.navigationBars["Expires In"].buttons["New Order"])
        let newOrderButton = app.navigationBars["Expires In"].buttons["New Order"]
        newOrderButton.tap()
        cancelButton.tap()
    }
    
    
    
    
    func testAddFoodItemDrag() {
        // Unsupported - should do nothing
    }
    
    func testCancelNewOrder() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }

}
