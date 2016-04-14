//
//  GetThatOrderUITests.swift
//  Foodini
//
//  Created by NOT_COMP401 on 4/13/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class GetThatOrderUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //pretty much copied from Seth's DriversOrdersUITests, because that's what's needed here: two orders
    //must be signed in when the test begins
    func test1_MakeDummyDataForGetThatOrder() {
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
        tablesQuery.textFields["Title"].typeText("test food")
        
        let doneButton = app.navigationBars["Food item"].buttons["Done"]
        doneButton.tap()
        
        let selectADriverStaticText = tablesQuery.staticTexts["Select a driver..."]
        selectADriverStaticText.tap()
        tablesQuery.staticTexts["Any driver"].tap()
        
        let selectDeliveryLocationStaticText = tablesQuery.staticTexts["Select delivery location..."]
        selectDeliveryLocationStaticText.tap()
        tablesQuery.textFields["Custom delivery location..."].tap()
        let newlocation = tablesQuery.textFields["Custom delivery location..."]
        newlocation.typeText("MAP North lobby")
        tablesQuery.buttons["Add"].tap()
        
        let mapStaticText = tablesQuery.staticTexts["MAP North lobby"]
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
        tablesQuery.textFields["Title"].typeText("test2")
        doneButton.tap()
        selectADriverStaticText.tap()
        tablesQuery.staticTexts["LoewSD1"].tap()
        selectDeliveryLocationStaticText.tap()
        mapStaticText.tap()
        selectExpirationTimeStaticText.tap()
        pickerWheel.tap()
        app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("1 hour")
        newOrderButton.tap()
        submitButton.tap()
    }
    
    //need to be logged in to begin this test
    func test2_CancelOrderFromMyOrders() {
        let app = XCUIApplication()
        let tablesQuery = app.tables

        //now the meat of the actual test:
        app.navigationBars["Home"].buttons["My orders"].tap()
        
        tablesQuery.staticTexts["Any driver"].tap()//will fail if the user doing testing has another order from "Any Driver"...
        tablesQuery.buttons["Cancel"].tap()
        
        let yesButton = app.sheets["Cancel"].collectionViews.buttons["Yes"]
        yesButton.tap()
        
        sleep(1)//give the new button a bit of time to load
        
        app.navigationBars["Order Information"].buttons["My Orders"].tap()
        XCTAssert((tablesQuery.staticTexts["Any driver"].exists) == false)
    }
    
    func test3_AcquireOrderFromGetThatOrderMyOrders() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
        
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("LoewSD1")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("hello")
        app.buttons["Go"].tap()
        
        //meat of the test:
        app.buttons["I'm picking up food"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Sweet Jeanie's"].tap()
        tablesQuery.buttons["I'll get that"].tap()
        
        let yesButton = app.sheets["Pick up order"].collectionViews.buttons["Yes"]
        yesButton.tap()
        
        sleep(1)//give the new button a bit of time to load
        
        XCTAssert(app.buttons["Acquired ✓"].exists == true)
        XCTAssert(app.buttons["Acquired ✓"].enabled == false)
    }
    
    //again, must be logged in at first
    //this function just gets the user state to where it needs to be for the next test
    func test4_DummyInterimDataModifier() {
        let app = XCUIApplication()
        let tablesQuery = app.tables

        app.navigationBars["Home"].buttons["My orders"].tap()
        tablesQuery.staticTexts["Sweet Jeanie's"].tap()
        
        tablesQuery.buttons["I paid for the food"].tap()
        let collectionViewsQuery = app.alerts["Pay"].collectionViews
        collectionViewsQuery.textFields["$##.##"].typeText("3.59")
        collectionViewsQuery.buttons["Done"].tap()

        sleep(1)//give the new button a bit of time to load
        
        tablesQuery.buttons["I arrived at the delivery location"].tap()
        app.sheets["Delivery location"].collectionViews.buttons["Yes"].tap()
    }
    
    //requires a logged-in session
    func test5_ReimburseDriver(){
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
        
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Test")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("january")
        app.buttons["Go"].tap()
        
        app.navigationBars["Home"].buttons["My orders"].tap()
        let tablesQuery = app.tables

        //the meat of the test function
        tablesQuery.staticTexts["LoewSD1"].tap()
        app.tables.buttons["Reimburse driver"].tap()
        let collectionViewsQuery = app.alerts["Reimburse"].collectionViews
        collectionViewsQuery.textFields["$##.##"].typeText("3.59")
        collectionViewsQuery.buttons["OK"].tap()
        
        sleep(1)//give the new button a bit of time to load
        
        XCTAssert(app.buttons["Order completed"].exists == true)
        XCTAssert(app.buttons["Order completed"].enabled == false)
    }
}
