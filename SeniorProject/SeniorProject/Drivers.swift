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
    var availabilities = [PFDriverAvailability]()
    var drivers = [PFUser]()
    var unavailableDriversQuery = PFQuery(className: PFUnavailableRestaurant.parseClassName())
    var restaurant: String?
    
    let user = PFUser.currentUser()!
    
    func clearAvailabilities() {
        availabilities.removeAll()
    }
    
    func clear() {
        drivers.removeAll()
    }
    
    func getDrivers(completion: (success: Bool) -> Void) {
        clear()
        clearAvailabilities()
        
        getListOfAvailableDrivers() { success in
            if success {
                self.getListOfApplicableDrivers() { complete in
                    if complete {
                        completion(success: true)
                    } else {
                        logError("Failed to find drivers available for your restaurant")
                    }
                }
            } else {
                logError("Failed to retrieve list of available drivers")
            }
        }
    }
    
    func getListOfAvailableDrivers(completion: (success: Bool) -> Void) {
        let driversQuery = PFQuery(className: PFDriverAvailability.parseClassName())
        driversQuery.includeKey("driver")
        driversQuery.whereKey("isCurrentlyAvailable", equalTo: true)
        driversQuery.whereKey("driver", notEqualTo: user)
        driversQuery.orderByAscending("expirationDate")
        driversQuery.limit = 10
        driversQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                if let driversList = objects as? [PFDriverAvailability] {
                    for driverAvailability in driversList {
                        if let driver = driverAvailability.driver as? PFUser {
                            self.addDriver(driver)
                        }
                        self.addAvailability(driverAvailability)
                    }
                    completion(success: true)
                }
            } else {
                completion(success: false)
            }
        }
    }
    
    func getListOfApplicableDrivers(completion: (success: Bool) -> Void) {
        let unavailableQuery = PFQuery(className: PFUnavailableRestaurant.parseClassName())
        unavailableQuery.includeKey("driverAvailability.driver")
        unavailableQuery.whereKey("driverAvailability", containedIn: availabilities)
        unavailableQuery.whereKey("restaurant", notEqualTo: restaurant!)
        unavailableQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                if let driversList = objects as? [PFUnavailableRestaurant] {
                    for item in driversList {
                        if let driverAvailability = item.driverAvailability as? PFDriverAvailability {
                            if let driver = driverAvailability.driver as? PFUser {
                                self.findAndRemoveUnavailable(driver)
                            }
                        }
                    }
                    completion(success: true)
                }
            } else {
                completion(success: false)
            }
        }
    }
    
    func addAvailability(driver: PFDriverAvailability) {
        if !availabilities.contains(driver) {
            availabilities.append(driver)
        } else {
            logError("Duplicate driver")
        }
    }
    
    func addDriver(driver: PFUser) {
        if !drivers.contains(driver) {
            drivers.append(driver)
        } else {
            logError("Duplicate driver")
        }
    }
    
    func findAndRemoveUnavailable(driver: PFUser) {
        if drivers.contains(driver) {
            if let index = drivers.indexOf(driver) {
                drivers.removeAtIndex(index)
            }
        }
    }
    
}