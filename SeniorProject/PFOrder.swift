//
//  PFOrder.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/23/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class PFOrder: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var restaurantName: String
    @NSManaged var restaurantLoc: PFGeoPoint
    
    @NSManaged var OrderingUser: PFObject
    @NSManaged var driverToDeliver: PFObject?
    @NSManaged var destination: PFObject
    
    @NSManaged var isAnyDriver: Bool
    @NSManaged var expirationDate: NSDate
    
    @NSManaged var OrderState: String
    
    static func parseClassName() -> String {
        return "Order"
    }
}

extension PFObject {
    convenience init(withoutDataWithObjectId objectId: String?) {
        self.init(withoutDataWithObjectId: objectId)
    }
}