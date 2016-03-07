//
//  NewFoodItemViewControllerUITests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest


class NewFoodItemViewControllerUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFoodNameField(){
        
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        let enterFoodNameTextField = app.textFields["Enter Food Name"]
        enterFoodNameTextField.typeText("test")
        XCTAssert(enterFoodNameTextField.value as? String == "test")
        app.navigationBars["SeniorProject.NewFoodItemView"].buttons["New Order"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    func testFoodDescriptionField(){
        
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        app.textFields["Enter Food Name"].typeText("test")
        
        let app2 = app
        app2.buttons["Next"].tap()
        
        let enterFoodDescriptionTextField = app.textFields["Enter Food Description"]
        enterFoodDescriptionTextField.tap()
        enterFoodDescriptionTextField.typeText("test")
        app2.buttons["Done"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    func testCellValuesSet(){
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Food items").childrenMatchingType(.Button).element.tap()
        app.textFields["Enter Food Name"].typeText("test")
        
        let app2 = app
        app2.buttons["Next"].tap()
        
        let enterFoodDescriptionTextField = app.textFields["Enter Food Description"]
        enterFoodDescriptionTextField.tap()
        enterFoodDescriptionTextField.typeText("test")
        app2.buttons["Done"].tap()
        let cells = app.tables.cells
        //can't easily get vlues of cells, so just making sure that a cell was added
        XCTAssert(cells.count == 5)
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }
    
}
