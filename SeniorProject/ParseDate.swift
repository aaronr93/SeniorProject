//
//  ParseDate.swift
//  Foodini
//
//  Created by Michael Kytka on 2/20/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

extension NSDate {
    func yearsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func isFutureDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isPastDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

class ParseDate {
    static func timeLeft(date: NSDate) -> String {
        let dateObj = NSDate()
        var seconds = Double(date.secondsFrom(dateObj))
        var minutes: Double = 0
        var hours: Double = 0
        var days: Double = 0
        
        if date.isFutureDate(NSDate()) == true{
            days = floor(seconds/(60 * 60 * 24))
            let daysLeft = seconds/(60 * 60 * 24) - days
            hours = floor(daysLeft * 24)
            let hoursLeft = (daysLeft * 24) - hours
            minutes = floor(hoursLeft * 60)
            let minutesLeft = (hoursLeft * 60) - minutes
            seconds = floor(minutesLeft*60)
            let rv: String = "\(Int(hours)) hours \(Int(minutes)) minutes"
            return rv
        }
        let expiration:String = (PFUser.currentUser()?.username!)!
        let notification = Notification(content: "\(expiration) has expired!", sendToID: (PFUser.currentUser()?.objectId)!)
        notification.push()
        return "Expired"
    }
}