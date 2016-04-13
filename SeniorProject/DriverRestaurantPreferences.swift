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
    
    var availability: PFDriverAvailability?
    let driver = PFUser.currentUser()!
    var blacklist = [PFUnavailableRestaurant]()     // Unavailable restaurants; add to Parse
    var whitelist = [PFUnavailableRestaurant]()     // Available restaurants; remove from Parse
    var selectedExpirationTime: String?
    
    init() {
        // Retrieve the availability of the current user.
        let query = PFQuery(className: PFDriverAvailability.parseClassName())
        query.whereKey("driver", equalTo: driver)
        query.getFirstObjectInBackgroundWithBlock { (obj: PFObject?, error: NSError?) in
            if error == nil {
                self.availability = obj as? PFDriverAvailability
                
                //also, retrieve blacklist of restaurants
                let blacklistQuery = PFQuery(className: PFUnavailableRestaurant.parseClassName())
                blacklistQuery.includeKey("driverAvailability").whereKey("driverAvailability", equalTo: PFObject(withoutDataWithClassName: "DriverAvailability", objectId: self.availability!.objectId))
                blacklistQuery.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let items = objects {
                            for item in items {
                                let item = item as! PFUnavailableRestaurant
                                self.blacklist.append(item)
                            }
                        }
                    } else {
                        // Log details of the failure
                        logError("Error: \(error!) \(error!.userInfo)")
                    }
                }
            } else {
                // User's Availability doesn't exist; create it.
                self.availability = PFDriverAvailability(className: PFDriverAvailability.parseClassName())
                self.availability!.driver = self.driver
                self.availability!.expirationDate = NSDate().addHours(4)
                self.availability!.isCurrentlyAvailable = true
                self.availability!.saveInBackground()
            }
        }
    }
    
    // Adds the given restaurant to the list of Unavailable restaurants.
    func markUnavailable(rest: Restaurant) {
        let add = PFUnavailableRestaurant()
        add.restaurant = rest.name
        add.driverAvailability = availability!
        blacklist.append(add)
    }
    
    // Removes the given restaurant from the list of Unavailable restaurants.
    func markAvailable(rest: Restaurant) {
        var removeIndex = 0
        var toAdd: PFUnavailableRestaurant!
        for item in blacklist {
            if item.restaurant == rest.name {
                removeIndex = blacklist.indexOf(item)!
                toAdd = item
            }
        }
        whitelist.append(toAdd)
        blacklist.removeAtIndex(removeIndex)
    }
    
    // Returns whether or not the driver is listed as Unavailable for the given Restaurant.
    func isUnavailable(name: String) -> Bool {
        for item in blacklist {
            if item.restaurant == name {
                return true
            }
        }
        return false
    }
    
    func clearRestaurants() {
        for item in blacklist {
            item.deleteInBackground()
        }
        blacklist.removeAll()
    }
    
    // Adds unavailable restaurants and removes available restaurants from Parse
    func saveAll() {
        for item in blacklist {
            item.saveInBackground()
        }
        for item in whitelist {
            item.deleteInBackground()
        }
    }
    
    // Returns the general availability of the driver (isCurrentlyAvailable)
    func driverAvailability() -> Bool {
        if let pref = availability {
            return pref.isCurrentlyAvailable
        }
        return false
    }
    
    // Sets the general availability of the driver (isCurrentlyAvailable)
    func setDriverAvailability(to switchState: Bool) {
        if let pref = availability {
            pref.isCurrentlyAvailable = switchState
            pref.saveInBackground()
        }
    }
    
    func getBlacklistFromParse(completion: (success: Bool) -> Void) {
        let driverAvailablityQuery = PFQuery(className: PFDriverAvailability.parseClassName())
        driverAvailablityQuery.whereKey("driver", equalTo: driver)
        
        driverAvailablityQuery.findObjectsInBackgroundWithBlock { (driverAvailabilityObjects, error) -> Void in
            if error == nil {
                if let driverAvailablities = driverAvailabilityObjects {
                    if !driverAvailablities.isEmpty {
                        let unavailQuery = PFQuery(className: PFUnavailableRestaurant.parseClassName())
                        unavailQuery.whereKey("driverAvailability", equalTo: driverAvailablities.first!)
                        unavailQuery.findObjectsInBackgroundWithBlock({ (unavailObjects: [PFObject]?, errorUnavail) -> Void in
                            if errorUnavail == nil {
                                if let unavailables = unavailObjects {
                                    if !unavailables.isEmpty {
                                        self.blacklist = unavailables as! [PFUnavailableRestaurant]
                                    }
                                }
                            }
                            completion(success: true)
                        })
                    } else {
                        logError("No driver availabilities!")
                        completion(success: false)
                    }
                }
            } else {
                logError("Error querying driver availibility")
                completion(success: false)
            }
        }
    }
    
    func getExpirationTime() -> String {
        return availability!.expiresIn()
    }
    
}