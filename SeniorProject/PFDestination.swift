//
//  PFDestination.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 3/24/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class PFDestination: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var name: String
    @NSManaged var customer: PFObject
    @NSManaged var destination: PFGeoPoint
    
    static func parseClassName() -> String {
        return "CustomerDestinations"
    }
}