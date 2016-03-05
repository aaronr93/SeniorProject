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
    let itemsForDriverQuery = PFQuery(className: "DriverAvailability")
    var restaurant = "Sheetz"
    
    init() {
        itemsForDriverQuery.includeKey("driver")
        itemsForDriverQuery.includeKey("username")
        itemsForDriverQuery.whereKey("isCurrentlyAvailable", equalTo: true)
        
        availableDrivers.includeKey("restaurant")
        availableDrivers.limit = 10
        availableDrivers.whereKey("name", equalTo: restaurant)
    }    
    
    func add(driver: PFObject) {
        if !list.contains(driver) {
            list.append(driver)
        } else {
            print("Duplicate driver")
        }
    }
    
}