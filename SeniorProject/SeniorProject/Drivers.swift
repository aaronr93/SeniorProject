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
    var list = [PFUser]()
    var unavailableDriversQuery = PFQuery(className: "DriverUnavailableRestaurants")
    var restaurant: String?
    
    func clear() {
        list.removeAll()
    }
    
    func getNonDriversFromDB(completion: (success: Bool) -> Void) {
        
        unavailableDriversQuery.includeKey("driverAvailability")
        unavailableDriversQuery.limit = 10
        unavailableDriversQuery.whereKey("restaurant", notEqualTo: restaurant!)
        unavailableDriversQuery.whereKey("driver", notEqualTo: PFUser.currentUser()!)
        unavailableDriversQuery.orderByDescending("createdAt")
        unavailableDriversQuery.includeKey("driverAvailability.driver")
        
        unavailableDriversQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let availableDrivers = objects as? [PFUnavailableRestaurant] {
                    for driver in availableDrivers {
                        let driverAvailability = driver.driverAvailability as? PFDriverAvailability
                        if let currentlyAvailable = driverAvailability?.isCurrentlyAvailable {
                            if (currentlyAvailable) {
                                // If the driver is currently available then add the item
                                let driver_obj = driverAvailability?.driver as! PFUser
                                self.add(driver_obj)
                            }
                        }
                    }
                    completion(success: true)
                }
            } else {
                // Log details of the failure
                logError("Error: \(error!) \(error!.userInfo)")
                completion(success: false)
            }
        }

    }
    
    func add(driver: PFUser) {
        if !list.contains(driver) {
            list.append(driver)
        } else {
            logError("Duplicate driver")
        }
    }
    
}