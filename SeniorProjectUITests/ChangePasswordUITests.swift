//
//  ChangePasswordUITests.swift
//  Foodini
//
//  Created by Zach Nafziger on 4/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
class ChangePasswordUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testChangePassword(){
        //in order for this to work, the password must be testpass
        let onOff = [false, true]
        let app = XCUIApplication()
        let username = "Testman"
        let password = "testpass"
        let newPassword = "newpass"
        let settingsButton = app.navigationBars["Home"].buttons["Settings"]
        let signOutButton = app.buttons["Sign out"]
        let usernameTextField = app.textFields["Name"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        
        
        settingsButton.tap()
        signOutButton.tap()
        
        
        usernameTextField.tap()
        usernameTextField.typeText(username)
        
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.typeText("\r")
       
        
        XCTAssertNotNil(settingsButton, "Couldn't perform initial login, please confirm password for \(username) is \(password)")
        
        for oldPass in onOff{
            for newPass in onOff{
                for confirmPass in onOff{
                    
                    //go to the password screen
                    settingsButton.tap()
                    app.buttons["Change password"].tap()
                    
                    //type in the appropriate elements
                    if(oldPass){
                        //type in the old password
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(0).tap()
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(0).typeText(password)
                    }
                    if (newPass){
                        //type in the new password
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(1).tap()
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(1).typeText(newPassword)
                    }
                    
                    if (confirmPass){
                        //type in the confirm password
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(2).tap()
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(2).typeText(newPassword)
                    }
                    
                    //submit
                    app.buttons["Submit"].tap()
                    
                    if(oldPass && newPass && confirmPass){
                        //go to the login screen
                        addUIInterruptionMonitorWithDescription("Location Dialog") { (alert) -> Bool in
                            app.alerts["Password Changed"].collectionViews.buttons["Ok"].tap()
                            return true
                        }
                        sleep(4)
                        usernameTextField.tap()
                        usernameTextField.typeText(username)
                        passwordSecureTextField.tap()
                        
                        // assert that the password has been changed
                        passwordSecureTextField.typeText(newPassword)
                        passwordSecureTextField.typeText("\r")
                        XCTAssertNotNil(settingsButton)
                        
                        //change back to the old password
                        settingsButton.tap()
                        app.buttons["Change password"].tap()
                        
                        
                        //type in the new password
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(0).tap()
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(0).typeText(newPassword)
                        //type in the old password
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(1).tap()
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(1).typeText(password)
                        //type in the confirm password
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(2).tap()
                        element.childrenMatchingType(.SecureTextField).elementBoundByIndex(2).typeText(password)
                        app.buttons["Submit"].tap()
                        addUIInterruptionMonitorWithDescription("Location Dialog") { (alert) -> Bool in
                            app.alerts["Password Changed"].collectionViews.buttons["Ok"].tap()
                            return true
                        }
                        sleep(4)
                        usernameTextField.tap()
                        usernameTextField.typeText(username)
                        passwordSecureTextField.tap()
                        passwordSecureTextField.typeText(password)
                        passwordSecureTextField.typeText("\r")
                        XCTAssertNotNil(settingsButton)
                        app.navigationBars["Home"].buttons["Settings"].tap()
                        app.navigationBars["Settings"].buttons["Home"].tap()
                    }
                    else {
                        //go to the login screen
                        
                        addUIInterruptionMonitorWithDescription("Location Dialog") { (alert) -> Bool in
                            app.alerts["Whoops!"].collectionViews.buttons["Ok"].tap()
                            return true
                        }
                        sleep(2)
                        XCUIApplication().navigationBars["Foodini.ChangePasswordView"].buttons["Settings"].tap()
                        signOutButton.tap()
                        usernameTextField.tap()
                        usernameTextField.typeText(username)
                        passwordSecureTextField.tap()
                        //assert that the password hasn't been changed
                        passwordSecureTextField.typeText(password)
                        passwordSecureTextField.typeText("\r")
                        XCTAssertNotNil(settingsButton)
                        app.navigationBars["Home"].buttons["Settings"].tap()
                        app.navigationBars["Settings"].buttons["Home"].tap()
                    }
                    
                    
                }
            }
        }
    }
    
}
