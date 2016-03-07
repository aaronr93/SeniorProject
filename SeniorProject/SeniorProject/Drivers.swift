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
    var availableDrivers = PFQuery(className: "DriverAvailableRestaurants")
    var restaurant = "Sheetz"
    
    init() {
        availableDrivers.limit = 10
        
        let availability = PFQuery(className: "DriverAvailability")
        availability.whereKey("isCurrentlyAvailable", equalTo: true)
        
        var drivers = [PFObject]()
        availability.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        drivers.append(item)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        let rests = PFQuery(className: "Restaurant")
        rests.whereKey("name", equalTo: restaurant)
        
        var restaurants = [PFObject]()
        rests.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        restaurants.append(item)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        availableDrivers.whereKey("driver", containedIn: drivers)
        availableDrivers.whereKey("restaurant", containedIn: restaurants)
    }
    
    func add(driver: PFObject) {
        if !list.contains(driver) {
            list.append(driver)
        } else {
            print("Duplicate driver")
        }
    }
    
}