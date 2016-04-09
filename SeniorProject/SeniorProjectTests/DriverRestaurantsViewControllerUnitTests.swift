//
//  DriverRestaurantsViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class DriverRestaurantsViewControllerUnitTests: XCTestCase {
    var testVC = DriverRestaurantsViewController()
    override func setUp() {
        super.setUp()
        testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("driverRestaurants") as! DriverRestaurantsViewController

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testVC.prefs)
        XCTAssertNotNil(testVC.POIs)
        XCTAssertNotNil(testVC.driver)
        XCTAssertNotNil(testVC.currentLocation)
        XCTAssertEqual(testVC.sectionHeaders, ["Restaurants I'll go to", "When I'm available"])
        
    }
    
    //nothing to test in viewDidLoad
    
    func testNumberOfRows(){
        let sectionAmounts = [2, testVC.POIs.restaurants.count]
        let tv = testVC.tableView
        for (index, amount) in sectionAmounts.enumerate(){
            XCTAssertEqual(testVC.tableView(tv, numberOfRowsInSection: index), amount)
        }
    }
    
    func testDidChangeSwitch(){
        let testCell = AvailabilityCell()
        testVC.didChangeSwitchState(testCell, isOn: false)
        XCTAssertEqual(testVC.prefs.driverAvailability(),false)

        
    }
    
    func testCurrentlyAvailable(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()

        XCTAssertEqual(testVC.currentlyAvailable(now), false)
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Hour,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        XCTAssertEqual(testVC.currentlyAvailable(future), true)

    }
    
    
    //unable to unit test cellforrow, cellforrestaurants, cell for settings, prepareForSegue, didSelectRowAtIndexPath, markExistingPreference
    
    
    
    
}
