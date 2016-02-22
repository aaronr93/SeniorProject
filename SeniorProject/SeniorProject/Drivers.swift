//
//  Drivers.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/21/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class Drivers {
    var list = [PFObject]()
    let itemsForDriverQuery = PFQuery(className:"DriverAvailability")
    
    init() {
        itemsForDriverQuery.includeKey("driver")
        itemsForDriverQuery.includeKey("username")
        itemsForDriverQuery.limit = 10
        itemsForDriverQuery.whereKey("isCurrentlyAvailable", equalTo: true)
    }
    
    func add(driver: PFObject) {
        if !list.contains(driver) {
            list.append(driver)
        } else {
            print("Duplicate driver")
        }
    }
    
    func getDriversFromParse() {
        itemsForDriverQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.add(item)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}