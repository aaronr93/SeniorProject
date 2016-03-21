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
    
    // Overloaded function to add an object of class `Restaurant` to the
    //   database. This function converts the Restaurant `toAdd` into a
    //   PFObject before adding it to the local list of Restaurants.
    func addRestaurant(toAdd: Restaurant) {
        // Create a local PFObject to which `toAdd` will be converted
        let restaurant = PFObject(className: "Restaurant")
        
        // Convert the restaurant's name
        restaurant["name"] = toAdd.name
        
        // Convert the restaurants GeoPoint
        let loc = toAdd.loc.location!
        let geoPoint = PFGeoPoint(location: loc)
        restaurant["locationCoord"] = geoPoint
        
        // If they exist, convert the restaurant's other optional values
        if let objectId = toAdd.objectId {
            restaurant.objectId = objectId
        }
        
        if let address = toAdd.address {
            restaurant["address"] = address
        }
        
        if let city = toAdd.city {
            restaurant["city"] = city
        }
        
        if let state = toAdd.state {
            restaurant["state"] = state
        }
        
        if let zip = toAdd.zip {
            restaurant["zip"] = zip
        }
        
        // Add to the list of Restaurant PFObjects, ready
        //   to be pushed to the Parse class
        addRestaurant(restaurant)
    }
    
    func removeRestaurant(toRemove: PFObject) {
        if let removeIndex = restaurants.indexOf(toRemove) {
            // Check if the restaurant we're trying toRemove actually is
            //   still there; if so, remove it.
            restaurants.removeAtIndex(removeIndex)
        } else {
            // If the restaurant toRemove does not exist in Parse:
            logError("Restaurant to remove does not exist in preferences.")
        }
    }
    
    func getFromParse(completion: (success: Bool) -> Void) {
        let getNearbyRestaurants = PFQuery(className:"Restaurant")
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
    
    func getRestaurantNames() -> [String] {
        var restaurantNames = [String]()
        for item in restaurants {
            let name = item["name"] as! String
            restaurantNames.append(name)
        }
        return restaurantNames
    }
    
    func getRestaurantCoords() -> [PFGeoPoint] {
        var geoPoints = [PFGeoPoint]()
        for item in restaurants {
            let loc = item["locationCoord"] as! PFGeoPoint
            geoPoints.append(loc)
        }
        return geoPoints
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