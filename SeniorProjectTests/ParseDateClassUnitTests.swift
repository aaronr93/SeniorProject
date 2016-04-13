//
//  ParseDateClassUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/18/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
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
    
    func testHoursFrom(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Hour,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Hour,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let futureTest = future.hoursFrom(now)
        XCTAssert(futureTest == 1)
        
        let pastTest = past.hoursFrom(now)
        XCTAssert(pastTest == -1)
        
    }
    
    func testMinutesFrom(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let futureTest = future.minutesFrom(now)
        XCTAssert(futureTest == 1)
        
        let pastTest = past.minutesFrom(now)
        XCTAssert(pastTest == -1)
        
    }
    
    func testIsFutureDate(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let pastTest = past.isFutureDate(now)
        let futureTest = future.isFutureDate(now)
        
        //positive test
        XCTAssert(futureTest)
        //negative test
        XCTAssertFalse(pastTest)
    }
    
    func testIsPastDate(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let past = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        let pastTest = past.isPastDate(now)
        let futureTest = future.isPastDate(now)
        
        //positive test
        XCTAssert(pastTest)
        //negative test
        XCTAssertFalse(futureTest)
    }
    
    func testEqualToDate(){
        let now = NSDate()
        
        //positive test
        XCTAssert(now.isEqualToDate(now))
        
        //negative test
        let calendar = NSCalendar.currentCalendar()
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Minute,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        XCTAssertNotNil(now.isEqualToDate(future))
        
        
    }
    
    func testAddDays(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Day,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        //positive test
        XCTAssert(now.addDays(1) == future)
        //negative test
        XCTAssertFalse(now.addDays(2) == future)
        
    }
    
    func testAddHours(){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let future = calendar.dateByAddingUnit(
            NSCalendarUnit.Hour,
            value: 1,
            toDate: now,
            options: NSCalendarOptions.init(rawValue: 0)
            )! as NSDate
        
        //positive test
        XCTAssert(now.addHours(1) == future)
        //negative test
        XCTAssertFalse(now.addHours(2) == future)
        
    }
    
    
    
    

}
