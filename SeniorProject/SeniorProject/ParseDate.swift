//
//  ParseDate.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/20/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

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
}

class ParseDate {
    static func timeLeft(date: NSDate) -> String {
        let dateObj = NSDate()
        var seconds = Double(dateObj.secondsFrom(date))
        var minutes: Double = 0
        var hours: Double = 0
        var days: Double = 0
        
        if seconds > 0 {
            days = floor(seconds/(60 * 60 * 24))
            let daysLeft = seconds/(60 * 60 * 24) - days
            hours = floor(daysLeft * 24)
            let hoursLeft = (daysLeft * 24) - hours
            minutes = floor(hoursLeft * 60)
            let minutesLeft = (hoursLeft * 60) - minutes
            seconds = floor(minutesLeft*60)
            let rv: String = "\(Int(days)) days \(Int(hours)) hours \(Int(minutes)) min"
            return rv
        } else {
            return ""
        }
    }
}