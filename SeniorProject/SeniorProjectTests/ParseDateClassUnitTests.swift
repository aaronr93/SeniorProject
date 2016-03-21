//
//  ParseDateClassUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/18/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class ParseDateClassUnitTests: XCTestCase {
    
    var testObject = ParseDate()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testObject)
    }
    
    
    func testTimeLeft(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        //future should return time left
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Hour,
            value: 1, // adding two hours
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
        )! as NSDate
        let futureTest = ParseDate.timeLeft(future)
        XCTAssert(futureTest == "0 days 0 hours 59 min", "timeLeft returned \(futureTest)")
        
        //past should return expired
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Hour,
            value: -1, // adding two hours
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        XCTAssert(ParseDate.timeLeft(past) == "expired")
        
        
        
    }
    
    func testYearsFrom(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Year,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Year,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let futureTest = future.yearsFrom(now)
        XCTAssert(futureTest == 1)
        
        let pastTest = past.yearsFrom(now)
        XCTAssert(pastTest == -1)
        
    }
    
    func testMonthsFrom(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Month,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Month,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let futureTest = future.monthsFrom(now)
        XCTAssert(futureTest == 1)
        
        let pastTest = past.monthsFrom(now)
        XCTAssert(pastTest == -1)

    }
    
    func testWeeksFrom(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.WeekOfYear,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.WeekOfYear,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let futureTest = future.weeksFrom(now)
        XCTAssert(futureTest == 1)
        
        let pastTest = past.weeksFrom(now)
        XCTAssert(pastTest == -1)
        
    }
    
    func testDaysFrom(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Day,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Day,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let futureTest = future.daysFrom(now)
        XCTAssert(futureTest == 1)
        
        let pastTest = past.daysFrom(now)
        XCTAssert(pastTest == -1)
        
    }
    
    

}
