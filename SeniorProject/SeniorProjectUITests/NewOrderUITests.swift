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
    
    func testSelectRestaurant() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        
        let tablesQuery = app.tables
        let selectRestaurantStaticText = tablesQuery.staticTexts["Select restaurant..."]
        //not selecting a restaurant - none selected
        selectRestaurantStaticText.tap()
        let newOrderButton = app.navigationBars["Select Restaurant"].buttons["New Order"]
        newOrderButton.tap()
        XCTAssertNotNil(selectRestaurantStaticText) //if text still exists, a restaurant hasn't been selected
        //selecting a restaurant
        selectRestaurantStaticText.tap()
        let northCountryBrewingCompanyStaticText = tablesQuery.staticTexts["North Country Brewing Company"]
        northCountryBrewingCompanyStaticText.tap()
        XCTAssertNotNil(northCountryBrewingCompanyStaticText)
        northCountryBrewingCompanyStaticText.tap()
        XCTAssertNotNil(northCountryBrewingCompanyStaticText)
        newOrderButton.tap()
        //not selecting a restaurant - already something selected
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }
    
    func testAddFoodItem(){
        
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Add new food item..."].tap()
        XCTAssertNotNil(tablesQuery.textFields["Title"])
        tablesQuery.textFields["Title"].tap()
        tablesQuery.textFields["Title"].typeText("test")
        app.buttons["Next:"].tap()
        tablesQuery.textFields["Details"].tap()
        tablesQuery.textFields["Details"].typeText("test")
        tablesQuery.textFields.containingType(.Button, identifier:"Clear text").element
        app.navigationBars["Food item"].buttons["Done"].tap()
        XCTAssertNotNil(app.navigationBars["New Order"].buttons["Cancel"])
                        
    }
    
    func testAddFoodItemII(){
        testAddFoodItem()
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Add new food item..."].tap()
        XCTAssertNotNil(tablesQuery.textFields["Title"])
        tablesQuery.textFields["Title"].tap()
        tablesQuery.textFields["Title"].typeText("test")
        app.buttons["Next:"].tap()
        tablesQuery.textFields["Details"].tap()
        tablesQuery.textFields["Details"].typeText("test")
        tablesQuery.textFields.containingType(.Button, identifier:"Clear text").element
        app.navigationBars["Food item"].buttons["Done"].tap()
        XCTAssertNotNil(app.navigationBars["New Order"].buttons["Cancel"])
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }
    
    
    func testSelectDriver(){
        
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        //selecting nothing
        let tablesQuery = app.tables
        app.tables.staticTexts["Select a driver..."].tap()
        app.navigationBars["SeniorProject.ChooseDriverTableView"].buttons["New Order"].tap()
        XCTAssertNotNil(tablesQuery.staticTexts["Select a driver..."])
        //selecting any driver - the only consistent value on the menu
        tablesQuery.staticTexts["Select a driver..."].tap()
        tablesQuery.staticTexts["Any driver"].tap()
        XCTAssertNotNil(tablesQuery.staticTexts["Select a driver..."]) //should automatically be taken back
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
        
        
        
        
    }
    
    func testSelectLocation(){
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        app.tables.staticTexts["Select delivery location..."].tap()
        tablesQuery.textFields["Custom delivery location..."].tap()
        tablesQuery2.cells.containingType(.Button, identifier:"Add").childrenMatchingType(.TextField).element.typeText("test")
        tablesQuery.buttons["Add"].tap()
        app.navigationBars["Select Delivery Location"].buttons["New Order"].tap()
        app.tables.staticTexts["Select delivery location..."].tap()
        //new table item should exist, tapping it should not break
        XCTAssertNotNil(app.tables.element.cells.elementBoundByIndex(1))
        app.tables.element.cells.elementBoundByIndex(1).tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    func testSelectExpiration(){
        let hours = [0,1,2,3,4,5,6]
        let minutes = [0,15,30,45]
        let app = XCUIApplication()
        let newOrderButton = app.navigationBars["Expires In"].buttons["New Order"]
        let tablesQuery = app.tables
        let app2 = app
        app.buttons["I want food"].tap()
        tablesQuery.otherElements["FOOD"].tap()
        app2.tables.staticTexts["Select expiration time..."].tap()
        newOrderButton.tap()
        for hour in hours{
            for minute in minutes{
                tablesQuery.cells.containingType(.StaticText, identifier:"Expires in").childrenMatchingType(.StaticText).matchingIdentifier("Expires in").elementBoundByIndex(0).tap()
                XCTAssertNotNil(newOrderButton)
                var hourText = "hours"
                if(hour == 1){
                    hourText = "hour"
                }
                app2.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("\(hour) \(hourText)")
                app2.pickerWheels.elementBoundByIndex(1).adjustToPickerWheelValue("\(minute) minutes")
                newOrderButton.tap()
                XCTAssertNotNil(tablesQuery.cells.containingType(.StaticText, identifier:"Expires in").childrenMatchingType(.StaticText).matchingIdentifier("Expires in").elementBoundByIndex(0))
            }
        }
        
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    
    
   
    
    func testRequestCombinatoric(){
        //this tests every possible combination
        let onOff = [true, false]
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let selectRestaurantStaticText = tablesQuery.staticTexts["Select restaurant..."]
        for restaurant in onOff{
            for food in onOff{
                for driver in onOff{
                    for location in onOff{
                        for expiration in onOff{
                            //go to the new order
                            app.buttons["I want food"].tap()
                            
                            if restaurant{
                                selectRestaurantStaticText.tap()
                                tablesQuery.staticTexts.elementBoundByIndex(0).tap()
                            }
                            
                            if food{
                                tablesQuery.staticTexts["Add new food item..."].tap()
                                XCTAssertNotNil(tablesQuery.textFields["Title"])
                                tablesQuery.textFields["Title"].tap()
                                tablesQuery.textFields["Title"].typeText("test")
                                app.buttons["Next:"].tap()
                                tablesQuery.textFields["Details"].tap()
                                tablesQuery.textFields["Details"].typeText("test")
                                tablesQuery.textFields.containingType(.Button, identifier:"Clear text").element
                                app.navigationBars["Food item"].buttons["Done"].tap()
                            }
                            
                            if driver{
                                tablesQuery.staticTexts["Select a driver..."].tap()
                                tablesQuery.staticTexts["Any driver"].tap()
                            }
                            
                            if location{
                                tablesQuery.staticTexts["Select delivery location..."].tap()
                                tablesQuery.textFields["Custom delivery location..."].tap()
                                tablesQuery.cells.containingType(.Button, identifier:"Add").childrenMatchingType(.TextField).element.typeText("test")
                                tablesQuery.buttons["Add"].tap()
                                XCTAssertNotNil(app.tables.element.cells.elementBoundByIndex(1))
                                app.tables.element.cells.elementBoundByIndex(1).tap()
                            }
                            
                            if expiration{
                                tablesQuery.staticTexts["Select expiration time..."].tap()
                                app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("2 hours")
                                app.pickerWheels.elementBoundByIndex(1).adjustToPickerWheelValue("15 minutes")
                                app.navigationBars["Expires In"].buttons["New Order"].tap()
                            }
                            
                            tablesQuery.buttons["Submit"].tap()
                            
                            
                            if(restaurant && food && driver && location && expiration){
                                //if everything is filled out, make sure we're home
                                XCTAssertNotNil(app.navigationBars["Home"].buttons["My orders"])
                                app.navigationBars["Home"].buttons["My orders"].tap()
                                app.navigationBars["My Orders"].buttons["Home"].tap()
                            }
                            else{
                                // if not, check we're still on the new order page
                                XCTAssertNotNil(app.navigationBars["New Order"].buttons["Cancel"])
                                app.navigationBars["New Order"].buttons["Cancel"].tap()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func testCancelNewOrder() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }

}
