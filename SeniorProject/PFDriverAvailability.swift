//
//  PFDriverAvailability.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 3/23/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class PFDriverAvailability: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var driver: PFObject
    @NSManaged var expirationDate: NSDate
    @NSManaged var isCurrentlyAvailable: Bool
    
    func expiresIn() -> String {
        return ParseDate.timeLeft(expirationDate)
    }
    
    static func parseClassName() -> String {
        return "DriverAvailability"
    }
}