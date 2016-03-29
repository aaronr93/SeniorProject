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
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }
    
    func test_foodNameField() {
        
        let enterFoodNameTextField = app.textFields["Enter Food Name"]
        enterFoodNameTextField.typeText("test")
        XCTAssert(enterFoodNameTextField.value as? String == "test")
        app.navigationBars["SeniorProject.NewFoodItemView"].buttons["New Order"].tap()
    }
    
    func testAddFoodItemEmpty(){
        //if the food items are empty
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        app.buttons["Done"].tap()
        
        //should take us to edit food item screen, with no changes to the food item screen
        app.tables.element.cells.elementBoundByIndex(0).tap()
        XCTAssertNil(app.textFields["Enter Food Name"])
        app.navigationBars["Food item"].buttons["New Order"].tap()
    }
    
    func testCancelButton() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        app.buttons["Cancel"].tap()
        
        //should take us to edit food item screen, with no changes to the food item screen
        app.tables.element.cells.elementBoundByIndex(0).tap()
        XCTAssertNil(app.textFields["Enter Food Name"])
        app.navigationBars["Food item"].buttons["New Order"].tap()
    }
    
    func testDoneKeyWithEmptyFields() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        app.keyboards.buttons["Done"].tap()
        
        //should take us to edit food item screen, with no changes to the food item screen
        app.tables.element.cells.elementBoundByIndex(0).tap()
        XCTAssertNil(app.textFields["Enter Food Name"])
        app.navigationBars["Food item"].buttons["New Order"].tap()
    }
    
    func testDoneOnKeyboardWithFields() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        let titleField = app.tables.cells.textFields["Title"]
        titleField.tap()
        titleField.typeText("test")
        
        app.buttons["Next"].tap()
        
        let detailsField = app.tables.cells.textFields["Details"]
        detailsField.tap()
        detailsField.typeText("test")
        app.keyboards.buttons["Done"].tap()
        
        //should take us to edit food item screen, with no changes to the food item screen
        app.tables.element.cells.elementBoundByIndex(1).tap()
        XCTAssertNotNil(app.textFields["Enter Food Name"])
        app.navigationBars["Food item"].buttons["New Order"].tap()
    }
    
    func test_foodDescriptionField() {
        
        let titleField = app.tables.cells.textFields["Title"]
        titleField.tap()
        titleField.typeText("test")
        
        app.buttons["Next"].tap()
        
        let detailsField = app.tables.cells.textFields["Details"]
        detailsField.tap()
        detailsField.typeText("test")
        app.buttons["Done"].tap()
    }
    
    func test_cellValuesSet() {
        
        let titleField = app.tables.cells.textFields["Title"]
        titleField.tap()
        titleField.typeText("test")
        
        app.buttons["Next"].tap()
        
        let detailsField = app.tables.cells.textFields["Details"]
        detailsField.tap()
        detailsField.typeText("test")
        app.buttons["Done"].tap()
        
        let cells = app.tables.cells
        //can't easily get vlues of cells, so just making sure that a cell was added
        XCTAssert(cells.count == 5)
        
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
    }
    
}
