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
    
    func addRestaurant(toAdd: Restaurant) {
        let restaurant = PFObject(className: "Restaurant")
        restaurant["name"] = toAdd.name
        let loc = toAdd.loc.location!
        let geoPoint = PFGeoPoint(location: loc)
        restaurant["locationCoord"] = geoPoint
        addRestaurant(restaurant)
    }
    
    func removeRestaurant(toRemove: PFObject) {
        if let removeIndex = restaurants.indexOf(toRemove) {
            restaurants.removeAtIndex(removeIndex)
        } else {
            logError("Restaurant to remove does not exist in preferences.")
        }
    }
    
    func getFromParse(completion: (success: Bool) -> Void) {
        let getNearbyRestaurants = PFQuery(className:"Restaurant")
        
        //itemsForDriverQuery.includeKey("name")
        getNearbyRestaurants.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.addRestaurant(item)
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