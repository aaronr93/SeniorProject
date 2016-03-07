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
    //let itemsForDriverQuery = PFQuery(className: "DriverAvailability")
    var restaurant : PFObject?
    
    func getDriversFromDB(completion: (success: Bool) -> Void){
        
        /*itemsForDriverQuery.includeKey("driver")
        itemsForDriverQuery.whereKey("isCurrentlyAvailable", equalTo: true)*/
        
        availableDrivers.includeKey("restaurant")
        availableDrivers.limit = 10
        availableDrivers.whereKey("restaurant", equalTo: restaurant!)
        availableDrivers.whereKey("driver", notEqualTo: PFUser.currentUser()!)
        availableDrivers.orderByDescending("createdAt")
        
        availableDrivers.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.add(item)
                    }
                    print(self.list)
                    completion(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion(success: false)
            }
        }

    }
    
    func add(driver: PFObject) {
        if !list.contains(driver) {
            list.append(driver)
        } else {
            print("Duplicate driver")
        }
    }
    
}