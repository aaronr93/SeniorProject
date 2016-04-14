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
    let destinationQuery = PFQuery(className: "CustomerDestinations")
    let me = PFUser.currentUser()!
    
    func add(destination: Destination) {
        if !history.contains( {$0.name == destination.name} ) {
            history.append(destination)
        }
    }
    
    func remove(destination: Destination) {
        if let removeIndex = history.indexOf( {$0.name == destination.name} ) {
            history.removeAtIndex(removeIndex)
        } else {
            logError("Destination item to remove does not exist.")
        }
    }
    
    func addDestinationItemToDB(name: String, completion: (success: Bool) -> Void) {
        let dest = PFDestination()
        dest.name = name
        dest.customer = me
        
        dest.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if success && error == nil {
                let destination = Destination(name: dest.name, id: dest.objectId!)
                self.add(destination)
                completion(success: true)
            } else {
                logError("Error saving destination to database")
                completion(success: false)
            }
        })
    }
    
    func getDestinationItemsFromParse(completion: (success: Bool) -> Void) {
        let user = PFUser.currentUser()!
        // Only find destinations for the current user
        destinationQuery.whereKey("customer", equalTo: user)
        destinationQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let items = objects {
                    for item in items {
                        let item = item as! PFDestination
                        let destinationItem = Destination(name: item.name, id: item.objectId!)
                        self.add(destinationItem)
                        // Populate the history of destinations
                    }
                    completion(success: true)
                }
            } else {
                logError("\(error!.userInfo)")
                completion(success: false)
            }
        }
    }
}