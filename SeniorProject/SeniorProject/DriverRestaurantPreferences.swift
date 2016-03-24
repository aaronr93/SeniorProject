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
    
    init() {
        let query = PFQuery(className: PFDriverAvailability.parseClassName())
        query.whereKey("driver", equalTo: driver)
        do {
            try availability = query.getFirstObject() as? PFDriverAvailability
        } catch {
            logError("Couldn't get the user's availability")
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
        for item in blacklist {
            if item.restaurant == rest.name {
                removeIndex = blacklist.indexOf(item)!
            }
        }
        blacklist.removeAtIndex(removeIndex)
    }
    
    func isUnavailable(rest: Restaurant) -> Bool {
        for item in blacklist {
            if item.restaurant == rest.name {
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
            item.saveEventually()
        }
    }
    
    func getBlacklistFromParse(completion: (success: Bool) -> Void) {
        let driverAvailablityQuery = PFQuery(className: PFDriverAvailability.parseClassName())
        driverAvailablityQuery.whereKey("driver", equalTo: driver)
        
        driverAvailablityQuery.findObjectsInBackgroundWithBlock { (driverAvailabilityObjects, error) -> Void in
            if error == nil
            {
            if let driverAvailablities = driverAvailabilityObjects {
                if !driverAvailablities.isEmpty {
                    let unavailQuery = PFQuery(className: PFUnavailableRestaurant.parseClassName())
                    unavailQuery.whereKey("driverAvailability", equalTo: driverAvailablities.first!)
                    unavailQuery.findObjectsInBackgroundWithBlock({ (unavailObjects: [PFObject]?, errorUnavail) -> Void in
                        if errorUnavail == nil
                        {
                        if let unavailables = unavailObjects {
                            if !unavailables.isEmpty {
                                self.blacklist = unavailables as! [PFUnavailableRestaurant]
                                completion(success: true)
                            } else {
                                logError("Error: Query yielded no results")
                                completion(success: false)
                            }
                        }
                        }
                    })
                } else {
                    logError("Error: No driver availabilities!")
                    completion(success: false)
                }
            }
            } else {
                logError("Error: Error querying driver availibility")
                completion(success: false)
            }
        }
    }
    
    func getExpirationTime() -> String {
        return availability!.expiresIn()
    }
    
}