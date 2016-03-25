//
//  PFUnavailableRestaurants.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/23/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class PFUnavailableRestaurant: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var driverAvailability: PFObject
    @NSManaged var restaurant: String
    
    static func parseClassName() -> String {
        return "DriverUnavailableRestaurants"
    }
}