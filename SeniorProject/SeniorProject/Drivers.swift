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
    var availableDriversForRestaurant = PFQuery(className: "DriverAvailableRestaurants")
    var restaurant : PFObject?
    
    func clear() {
        list.removeAll()
    }
    
    func getDriversFromDB(completion: (success: Bool) -> Void){
        
        
        availableDriversForRestaurant.includeKey("driverAvailability")
        availableDriversForRestaurant.includeKey("restaurant")
        availableDriversForRestaurant.limit = 10
        availableDriversForRestaurant.whereKey("restaurant", equalTo: restaurant!)
        availableDriversForRestaurant.whereKey("driver", notEqualTo: PFUser.currentUser()!)
        availableDriversForRestaurant.orderByDescending("createdAt")
        availableDriversForRestaurant.includeKey("driverAvailability.driver")
        
        
        availableDriversForRestaurant.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let drivers = objects {
                    for driver in drivers {
                        if let driverAvailability = driver["driverAvailability"]{
                            if let currentlyAvailable = driverAvailability["isCurrentlyAvailable"]{
                                if (currentlyAvailable as! Bool){//if the drive is currently available then add the item
                                    self.add(driver)
                                }
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
    
    func add(driver: PFObject) {
        if !list.contains(driver) {
            list.append(driver)
        } else {
            logError("Duplicate driver")
        }
    }
    
}