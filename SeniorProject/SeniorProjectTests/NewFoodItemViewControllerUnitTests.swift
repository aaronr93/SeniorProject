//
//  NewFoodItemViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class NewFoodItemViewControllerUnitTests: XCTestCase {
    let testVC = NewFoodItemTableViewController()
    override func setUp() {
        super.setUp()
        testVC.foodNameField = UITextField()
        testVC.foodDescriptionField = UITextField()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantation(){
        XCTAssertEqual(testVC.foodNameText, "")
        XCTAssertEqual(testVC.foodDescriptionText, "")
    }
    
    func testViewDidLoad(){
        let foodNames = ["testname", ""]
        let foodDescriptions = ["testdescription", ""]
        for name in foodNames{
            for desc in foodDescriptions{
                testVC.foodNameField = UITextField()
                testVC.foodDescriptionField = UITextField()
                testVC.foodNameText = name
                testVC.foodDescriptionText = desc
                testVC.viewDidLoad()
                XCTAssertEqual(testVC.foodNameField.text, name)
                 XCTAssertEqual(testVC.foodDescriptionField.text, desc)
            }
        }
    }
    
    //can't unit test touchesBegan
    
    //can't unit test textFieldShouldReturn
    
    func testSendFoodItem(){
        class testDelegate:NewFoodItemViewDelegate{
            func cancelNewItem(newOrderVC: NewFoodItemTableViewController){
                print("cancel")
            }
            func saveNewItem(newOrderVC: NewFoodItemTableViewController){
                print("save")
            }
            func editNewItem(newOrderVC: NewFoodItemTableViewController){
                print("edit")
            }
        }
        let indexNotNil = [true, false]
        let nameEmptyList = [true, false]
        for index in indexNotNil{
            for nameEmpty in nameEmptyList{
                testVC.delegate = testDelegate()
                testVC.foodNameField = UITextField()
                testVC.foodDescriptionField = UITextField()
                testVC.foodDescriptionField.text = "testdescription"
                testVC.index = nil
                if(index){
                    testVC.index = 0//theoretically, this does work, but it needs an actual order in the delegate or it throws an index out of bounds error
                }
                if(!nameEmpty){
                    testVC.foodNameField.text = "testfood"
                }
                XCTAssertTrue(testVC.sendFoodItem())
            }
        }
    }
}
