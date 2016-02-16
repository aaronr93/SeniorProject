//
//  ParseDate.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/16/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

class ParseDate {
    static func dateFromParseString(date: String) -> NSDate?{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let formattedDate = dateFormatter.dateFromString(date)
        return formattedDate
    }
}