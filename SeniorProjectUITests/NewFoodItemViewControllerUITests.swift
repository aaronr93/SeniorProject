//
//  NewFoodItemViewControllerUITests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest


class NewFoodItemViewControllerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        app.buttons["I want food"].tap()
        app.tables.staticTexts["Add new food item..."].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_foodNameField() {
        let title = app.tables.textFields.elementBoundByIndex(0)
        title.typeText("test")
        XCTAssert(title.value as! String == "test", "\(title.value!)")
    }
    
    func testAddFoodItemEmpty(){
        //if the food items are empty
        app.buttons["Done"].tap()
        //should take us to edit food item screen, with no changes to the food item screen
        XCTAssertNotNil(app.tables.staticTexts["Add new food item..."])
        app.tables.staticTexts["Add new food item..."].tap()
    }
    
    func testCancelButton() {
        app.buttons["Cancel"].tap()
        
        //should take us to edit food item screen, with no changes to the food item screen
        XCTAssertNotNil(app.tables.staticTexts["Add new food item..."])
        app.tables.staticTexts["Add new food item..."].tap()
    }
    
    func testDoneOnKeyboardWithFields() {
        let title = app.tables.textFields["Title"]
        title.typeText("test")
        
        app.buttons["Next"].tap()
        
        let details = app.tables.textFields["Details"]
        details.tap()
        details.typeText("test")
        app.keyboards.buttons["Done"].tap()
        
        //should take us to edit food item screen, with no changes to the food item screen
        app.tables.element.cells.elementBoundByIndex(1).tap()
        XCTAssertNotNil(app.textFields["Enter Food Name"])
    }
    
    func testFoodDescriptionField() {
        let detailsField = app.tables.cells.textFields["Details"]
        detailsField.tap()
        detailsField.typeText("test")
        app.navigationBars.buttons["Done"].tap()
    }
    
    func testCellValuesSet() {
        
        let titleField = app.tables.cells.textFields["Title"]
        titleField.tap()
        titleField.typeText("test")
        
        app.buttons["Next"].tap()
        
        let detailsField = app.tables.cells.textFields["Details"]
        detailsField.tap()
        detailsField.typeText("test")
        app.navigationBars.buttons["Done"].tap()
        
        let cells = app.tables.cells
        //can't easily get vlues of cells, so just making sure that a cell was added
        XCTAssert(cells.count == 6)
        
        app.tables.staticTexts["Add new food item..."].tap()
        
    }
    
}
