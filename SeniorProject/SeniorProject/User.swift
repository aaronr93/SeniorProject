//
//  PFUser.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/24/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class PFUser: PFUser {
    
    @NSManaged var phone: String
    @NSManaged var sendData: Bool
    @NSManaged var image: PFFile
    @NSManaged var locationCoord: PFGeoPoint
    @NSManaged var deleted: Bool
    @NSManaged var displayName: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}