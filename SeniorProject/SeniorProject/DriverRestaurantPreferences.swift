//
//  DriverRestaurantPreferences.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/19/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class DriverRestaurantPreferences {
    var active: Bool = false
    var restaurants = [PFObject]()
    var expirationTime = ""
    
    func addRestaurant(toAdd: PFObject) {
        if !restaurants.contains(toAdd) {
            restaurants.append(toAdd)
        } else {
            logError("Restaurant already exists in preferences.")
        }
    }
    
    func removeRestaurant(toRemove: PFObject) {
        if let removeIndex = restaurants.indexOf(toRemove) {
            restaurants.removeAtIndex(removeIndex)
        } else {
            logError("Restaurant to remove does not exist in preferences.")
        }
    }
    
    func setActive() {
        if restaurants.count > 0 {
            active = true
        } else {
            active = false
            logError("You cannot become active if no restaurants are selected")
        }
    }
    
    func setInactive() {
        active = false
    }
    
}