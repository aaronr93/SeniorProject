//
//  CustomerDestinations.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class CustomerDestinations {
    var history = [Destination]()
    var destinationID = ""
    let destinationQuery = PFQuery(className: PFDestination.parseClassName())
    let me = PFUser.currentUser()!
    
    func add(destination: String, completion: (success: Bool) -> Void) {
        if !history.contains( {$0.name == destination} ) {
            let dest = PFDestination()
            dest.name = destination
            dest.customer = me
            dest.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if success && error == nil {
                    let obj = Destination(name: dest.name, id: dest.objectId!)
                    self.history.append(obj)
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            })
        } else {
            completion(success: false)
        }
    }
    
    func remove(destination: String, completion: (success: Bool) -> Void) {
        if let removeIndex = history.indexOf( {$0.name == destination} ) {
            let dest = history[removeIndex]
            removeFromParse(dest, removeIndex: removeIndex) { result in
                completion(success: true)
            }
        } else {
            completion(success: false)
            logError("Destination item to remove does not exist.")
        }
    }
    
    func removeFromParse(dest: Destination, removeIndex: Int, completion: (success: Bool) -> Void) {
        let query = PFQuery(className: PFDestination.parseClassName())
        query.whereKey("name", equalTo: dest.name)
        query.whereKey("customer", equalTo: me)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                // Found objects to delete
                if let items = objects {
                    for item in items {
                        let item = item as! PFDestination
                        item.deleteInBackground()
                        self.history.removeAtIndex(removeIndex)
                    }
                    completion(success: true)
                } else {
                    completion(success: false)
                    logError("Failed to unwrap retrieved objects; there may be no Destinations in the database.")
                }
            } else {
                completion(success: false)
                logError("Destination to remove does not exist in Parse.\n\(error)")
            }
        }
    }
    
    func getDestinationItemsFromParse(completion: (success: Bool) -> Void) {
        // Only find destinations for the current user
        history.removeAll()
        destinationQuery.whereKey("customer", equalTo: me)
        destinationQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let items = objects {
                    for item in items {
                        let item = item as! PFDestination
                        let destinationItem = Destination(name: item.name, id: item.objectId!)
                        self.history.append(destinationItem) // Populate the history of destinations
                    }
                    completion(success: true)
                } else {
                    logError("Failed to unwrap retrieved objects; there may be no Destinations in the database.")
                    completion(success: false)
                }
            } else {
                logError("Could not get Destinations from Parse.\n\(error)")
                completion(success: false)
            }
        }
    }
}