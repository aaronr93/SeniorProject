//
//  HomeViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class HomeViewControllerUnitTests: XCTestCase {
    let testVC = HomeViewController()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewDidLoad() {
        XCTAssert(PFInstallation.currentInstallation()["user"] as! PFUser == PFUser.currentUser()!)
    }
    
    //nothing else can be unit tested
    
}
