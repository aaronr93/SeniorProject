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
    var blacklist = [PFUnavailableRestaurant]()
    var whitelist = [PFUnavailableRestaurant]()
    
    init() {
        let query = PFQuery(className: PFDriverAvailability.parseClassName())
        query.whereKey("driver", equalTo: driver)
        query.getFirstObjectInBackgroundWithBlock { (obj: PFObject?, error: NSError?) in
            if error == nil {
                self.availability = obj as? PFDriverAvailability
            } else {
                // Availability doesn't exist; create it.
                self.availability = PFDriverAvailability(className: PFDriverAvailability.parseClassName())
                self.availability!.driver = self.driver
                self.availability!.expirationDate = NSDate().addHours(4)
                self.availability!.isCurrentlyAvailable = true
                self.availability!.saveInBackground()
            }
        }
    }
    
    func markUnavailable(rest: Restaurant) {
        let add = PFUnavailableRestaurant()
        add.restaurant = rest.name
        add.driverAvailability = availability!
        blacklist.append(add)
    }
    
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
    
    func saveAll() {
        for item in blacklist {
            item.saveInBackground()
        }
        for item in whitelist {
            item.deleteInBackground()
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